Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab3BGBH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:07:26 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:33926 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab3BGBHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:07:25 -0500
Message-ID: <5112FE21.4020404@ahsoftware.de>
Date: Thu, 07 Feb 2013 02:06:41 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: MODSIGN without RTC?
References: <5112EA69.6010100@ahsoftware.de>
In-Reply-To: <5112EA69.6010100@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.02.2013 00:42, schrieb Alexander Holler:
> Hello,
>
> I wanted to try out MODSIGN with kernel 3.7.6 and I've just got hit by:
>
> [    1.346445] X.509: Cert 6a23533cec71c4c52a1618fb4d830e06aa90474e is
> not yet valid
>
> The reason is likely that the (ARM) device in question doesn't have a
> RTC (oh, that topic again ;) ) and gets it's time on boot through NTP.
>
> The used certificate was generated automatically. Having a look at it,
> the following is shown:
>
>         Validity
>              Not Before: Feb  6 02:56:46 2013 GMT
>              Not After : Jan 13 02:56:46 2113 GMT
>
> Without having thought about possible security problems, my first idea
> would be to let the validity start at 1970. As I never did such I never
> had thought about possible implications when doing such (e.g. I don't
> know if someone checks the start date for plausabilitiy)
>
> Another solution would be to retry loading of the certificate if the
> time gets set (and e.g. differs more than a year).
>
> Has someone already thought about how to solve that problem? Or did
> everyone use sane systems which have a (working) RTC?

Another option would be to make a configure option to just ignore the 
date. I'm not sure if I would like to use MODSIGN when I have to fear 
that the machine wouldn't start when the RTC fails or got set to a wrong 
date.

Regards,

Alexander

