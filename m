Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbaLKOE1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:04:27 -0500
Received: from mail.smart-weblications.de ([188.65.144.61]:38172 "EHLO
	mail.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802AbaLKOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:04:25 -0500
Message-ID: <5489A465.6090305@smart-weblications.de>
Date: Thu, 11 Dec 2014 15:04:21 +0100
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com> <alpine.LFD.2.11.1412042338370.4841@ja.home.ssi.bg> <5481173A.9060308@smart-weblications.de> <alpine.LFD.2.11.1412051126090.2522@ja.home.ssi.bg> <5481B944.2000002@smart-weblications.de> <alpine.LFD.2.11.1412072019410.1885@ja.home.ssi.bg> <54858948.2060007@smart-weblications.de> <alpine.LFD.2.11.1412082234350.2401@ja.home.ssi.bg> <5486CD9D.4060107@smart-weblications.de> <alpine.LFD.2.11.1412102331230.4043@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1412102331230.4043@ja.home.ssi.bg>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 10.12.2014 22:41, schrieb Julian Anastasov:>
> 	Hello,
>
> On Tue, 9 Dec 2014, Smart Weblications GmbH - Florian Wiessner wrote:
>
>> I rebuild everything with the two provided patches and still get:
>>
>> [  512.475449] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000014
>> [  512.481277] IP: [<ffffffffa013d470>] nf_ct_seqadj_set+0x60/0x90 [nf_conntrack]
>
> 	Same place, hm...
>
>> [  512.485323] CPU: 4 PID: 28142 Comm: vsftpd Not tainted 3.12.33 #5
>
> 	Above "#5" is same as previous oops. It means kernel
> is not updated. Or you updated only the IPVS modules after
> applying the both patches?

I did it with make-kpkg --initrd linux_image which only rebuilt the modules,
correct. I can retry with make clean before building the package

>
> 	You can also try without FTP tests to see if there
> are oopses in xfrm, so that we can close this topic and then
> to continue for the FTP problem on IPVS lists without
> bothering non-IPVS people.
>

yeah, it seems that the xfrm issue is away.


-- 

Mit freundlichen Grüßen,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Geschäftsführer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
