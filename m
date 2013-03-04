Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757007Ab3CDKs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:48:56 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:40993 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab3CDKsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:48:54 -0500
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Mar 2013 05:48:54 EST
X-Remote-IP: 213.191.128.133
Date: Mon, 04 Mar 2013 11:41:50 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130112 Icedove/17.0.2
MIME-Version: 1.0
To: Lenky Gao <lenky.gao@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com>
In-Reply-To: <CAAO_Xo7sEH5W_9xoOjax8ynyjLCx7GBpse+EU0mF=9mEBFhrgw@mail.gmail.com>
X-Spam-Score: ##
Message-ID: <51347A6E.8010608@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: Inactive memory keep growing and how to release it?
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20130304 #9657500, check: 20130304 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 43329 [Mar 04 2013]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.03.2013 10:52, Lenky Gao wrote:
> Hi,
>
> When i just run a test on Centos 6.2 as follows:
>
> #!/bin/bash
>
> while true
> do
>
> 	file="/tmp/filetest"
>
> 	echo $file
>
> 	dd if=/dev/zero of=${file} bs=512 count=204800 &> /dev/null
>
> 	sleep 5
> done
>
> the inactive memory keep growing:
>
> #cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):   420144 kB
> ...
> #cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):   911912 kB
> ...
> #cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):  1547484 kB
> ...
>
> and i cannot reclaim it:
>
> # cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):  1557684 kB
> # echo 3 > /proc/sys/vm/drop_caches
> # cat /proc/meminfo | grep Inactive\(fi
> Inactive(file):  1520832 kB
>
> I have tested on other version kernel, such as 2.6.30 and .6.11, the
> problom also exists.
>
> When in the final situation, i cannot kmalloc a larger contiguous
> memory, especially in interrupt context.
> Can you give some tips to avoid this?
>

The drop_caches mechanism doesn't free dirty page cache pages. And your 
bash script is creating a lot of dirty pages. Run it like this and see 
if it helps your case:

sync; echo 3 > /proc/sys/vm/drop_caches

Regards,
-- 
Zlatko
