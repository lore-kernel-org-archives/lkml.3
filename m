Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbbAFM5D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:57:03 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64449 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbbAFM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:57:00 -0500
Message-ID: <54ABDB98.9060504@suse.cz>
Date: Tue, 06 Jan 2015 13:56:56 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>,
        Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
CC: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com> <alpine.LFD.2.11.1412042338370.4841@ja.home.ssi.bg> <5481173A.9060308@smart-weblications.de> <alpine.LFD.2.11.1412051126090.2522@ja.home.ssi.bg> <5481B944.2000002@smart-weblications.de> <alpine.LFD.2.11.1412072019410.1885@ja.home.ssi.bg> <54858948.2060007@smart-weblications.de> <alpine.LFD.2.11.1412082234350.2401@ja.home.ssi.bg> <5486CD9D.4060107@smart-weblications.de> <alpine.LFD.2.11.1412102331230.4043@ja.home.ssi.bg> <5489A465.6090305@smart-weblications.de> <alpine.LFD.2.11.1412132211260.3229@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1412132211260.3229@ja.home.ssi.bg>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014, 09:19 PM, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 11 Dec 2014, Smart Weblications GmbH - Florian Wiessner wrote:
> 
>>>> [  512.485323] CPU: 4 PID: 28142 Comm: vsftpd Not tainted 3.12.33 #5
>>>
>>> 	Above "#5" is same as previous oops. It means kernel
>>> is not updated. Or you updated only the IPVS modules after
>>> applying the both patches?
>>
>> I did it with make-kpkg --initrd linux_image which only rebuilt the modules,
>> correct. I can retry with make clean before building the package
> 
> 	I just tested PASV and PORT with 3.12.33 including
> both patches (seq adj fix + ip_route_me_harder fix) and do not
> see any crashes in nf_ct_seqadj_set. If you still have problem
> with FTP send me more info offlist.
> 
>>> 	You can also try without FTP tests to see if there
>>> are oopses in xfrm, so that we can close this topic and then
>>> to continue for the FTP problem on IPVS lists without
>>> bothering non-IPVS people.
>>>
>>
>> yeah, it seems that the xfrm issue is away.
> 
> 	Thanks for the confirmation!

Great! Thanks for tracking it down.

So what should be done to fix the issue in stable 3.12? Are those
patches needed in the upstream kernel too? In that case I suppose it
will propagate to me through upstream. Otherwise, could you send "3.12
only" patches to stable@ so that I can apply them?

thanks,
-- 
js
suse labs
