Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaCaLGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:06:24 -0400
Received: from smtp-out-223.synserver.de ([212.40.185.223]:1055 "EHLO
	smtp-out-024.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752167AbaCaLGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:06:23 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25438
Message-ID: <53394C5E.2030207@metafoo.de>
Date: Mon, 31 Mar 2014 13:07:10 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Alessandro Zummo <a.zummo@towertech.it>
CC: Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        Greg KH <greg@kroah.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: kernfs/rtc: circular dependency between kernfs and ops_lock
References: <5308E3AE.3040405@oracle.com> <20140222205217.GC16272@mtj.dyndns.org> <20140224120427.6394d5dd@linux.lan.towertech.it> <5331FA9E.20506@oracle.com> <20140325233936.655a798e@linux.lan.towertech.it> <53321D04.2040102@oracle.com> <5337653D.6020002@oracle.com> <53384080.9020502@oracle.com> <20140331114627.5e1a4609@linux.lan.towertech.it> <53393AE4.505@metafoo.de> <20140331124351.43033c93@linux.lan.towertech.it>
In-Reply-To: <20140331124351.43033c93@linux.lan.towertech.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 12:43 PM, Alessandro Zummo wrote:
> On Mon, 31 Mar 2014 11:52:36 +0200
> Lars-Peter Clausen <lars@metafoo.de> wrote:
>
>> It's the same bug, device_unregister(&rtc->dev) will try to unregister all
>> sysfs files attached to the device and that function is still called with
>> the rtc mutex held.
>
>   rtc-cmos tries to unregister the rtc device in the probe function,
>   which should not be done.
>
>   the last patches fixes it. I'll keep trying to trigger the bug on my systems.
>

It doesn't really matter where it is unregistered. device_unregister() will 
(somewhere down it's callchain) take the kernfs lock, hence it must be 
callled with the rtc mutex being held.

- Lars
