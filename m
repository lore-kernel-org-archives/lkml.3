Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaCaMSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:18:35 -0400
Received: from smtp-out-226.synserver.de ([212.40.185.226]:1030 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752161AbaCaMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:18:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8482
Message-ID: <53395D4B.1010805@metafoo.de>
Date: Mon, 31 Mar 2014 14:19:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
References: <5308E3AE.3040405@oracle.com> <20140222205217.GC16272@mtj.dyndns.org> <20140224120427.6394d5dd@linux.lan.towertech.it> <5331FA9E.20506@oracle.com> <20140325233936.655a798e@linux.lan.towertech.it> <53321D04.2040102@oracle.com> <5337653D.6020002@oracle.com> <53384080.9020502@oracle.com> <20140331114627.5e1a4609@linux.lan.towertech.it> <53393AE4.505@metafoo.de> <20140331124351.43033c93@linux.lan.towertech.it> <53394C5E.2030207@metafoo.de> <20140331140344.6030c7da@linux.lan.towertech.it>
In-Reply-To: <20140331140344.6030c7da@linux.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 02:03 PM, Alessandro Zummo wrote:
> On Mon, 31 Mar 2014 13:07:10 +0200
> Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>> It doesn't really matter where it is unregistered. device_unregister() will
>> (somewhere down it's callchain) take the kernfs lock, hence it must be
>> callled with the rtc mutex being held.
>
>   Maybe device_remove_attrs could be called in the rtc base class,
>   before the device removal?
>

Just move the device_unregister() call outside the lock. I think the only 
thing that needs to be protected is the ops = NULL assignment. Moving the 
unregister after the unlock also means that the extra 
get_device()/put_device() pair can be removed.
