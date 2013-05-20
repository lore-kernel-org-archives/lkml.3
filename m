Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3ETBEX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 21:04:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56954 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab3ETBEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 21:04:22 -0400
X-Spam-Score: -100.8
Message-ID: <5199765F.5000905@asianux.com>
Date: Mon, 20 May 2013 09:03:27 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Consult] Why need we call device_remove_file() firstly before
 call device_unregister() ?
References: <5195C39F.9010101@asianux.com> <CACVXFVNiWwiXtubJSbE3z6-AyxcOBgyvhn+2diHyi5Nyj4XYeg@mail.gmail.com>
In-Reply-To: <CACVXFVNiWwiXtubJSbE3z6-AyxcOBgyvhn+2diHyi5Nyj4XYeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2013 07:06 PM, Ming Lei wrote:
> Hi,
> 
> On Fri, May 17, 2013 at 1:43 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> Hello All:
>>
>> I searched 'arch/*' and 'drivers/*' sub-directory, all of them are 'obey
>> this rule', even in device_unregister() itself, it also firstly calls
>> device_remove_file(), then call kobject_del().
>>
>> But after read the related code (fs/sysfs/*, drivers/base/core.c), it
>> seems kobject_del() -> sysfs_remove_dir() which will release all related
>> things (can instead of device_remove_file()).
>>
>> So in fact, we need not call device_remove_file() before call
>> device_unregister(), is it correct ?
> 
> Looks it is correct but it is a bit implicit.
> 

If really no other members reply within a week, we should treat your
opinion (or suggestion) as the final result conclusion within
linux-kernel@vger.kernel.org.  :-)


Thanks.
-- 
Chen Gang

Asianux Corporation
