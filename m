Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab3BFXm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 18:42:57 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:51413 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3BFXm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 18:42:56 -0500
Message-ID: <5112EA69.6010100@ahsoftware.de>
Date: Thu, 07 Feb 2013 00:42:33 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: MODSIGN without RTC?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I wanted to try out MODSIGN with kernel 3.7.6 and I've just got hit by:

[    1.346445] X.509: Cert 6a23533cec71c4c52a1618fb4d830e06aa90474e is 
not yet valid

The reason is likely that the (ARM) device in question doesn't have a 
RTC (oh, that topic again ;) ) and gets it's time on boot through NTP.

The used certificate was generated automatically. Having a look at it, 
the following is shown:

        Validity
             Not Before: Feb  6 02:56:46 2013 GMT
             Not After : Jan 13 02:56:46 2113 GMT

Without having thought about possible security problems, my first idea 
would be to let the validity start at 1970. As I never did such I never 
had thought about possible implications when doing such (e.g. I don't 
know if someone checks the start date for plausabilitiy)

Another solution would be to retry loading of the certificate if the 
time gets set (and e.g. differs more than a year).

Has someone already thought about how to solve that problem? Or did 
everyone use sane systems which have a (working) RTC?

Regards,

Alexander
