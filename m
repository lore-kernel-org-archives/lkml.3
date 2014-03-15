Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaCOHVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 03:21:30 -0400
Received: from nm23-vm4.bullet.mail.gq1.yahoo.com ([98.136.217.83]:39392 "EHLO
	nm23-vm4.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaCOHV3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 03:21:29 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 256135.50312.bm@omp1051.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=kvF/aqLhth2hWkheXKqzJYULElD60EzbfDK8q7tX63ZGPFcKOxuj7XsVh3p2g5Xxv6ULVQpYOC04r4j8b7Bs1+sjoWWJVIW/z9n7fCTA1V2P4fKYUwyy3D02BC35LhhvRNj/H8YljOS8x71+FqvZZUK9Vo4RjFRlLpiOcWFn800=;
X-YMail-OSG: nmgIjHIVM1mkqCWa0K2cTVhm.v8xJaUSj0Bo365HP95hkAr
 xctgDuz5UB0OehE2cQD2puCk5RiDIB.WyAl4gpZh_kiqFedmq3mmEodRs2lH
 G1HrcG3ymUWbO9D3IBzMCl0H1AzQjiqaFxqc8LJ2JKXyN5TuVXbx7h4EnqvP
 kM5yDxUeTacD9BLAux7UZP8C7gsPwYqC7YzoOHl16AuOZ3Ah7J4iYeVbCpN7
 IFPrK2Py8wBakrggZY4BUhDyu2kAOFkLDT9rgSS6GFMLbnuw5dyjwSeCuhBk
 TYNEF7uYkfxvm994IiAB4vFhHNVHhKa.8WjbywKiVEeyy_5vF.JEsRFoLFTL
 rRK_cTAD6aAJ6qNfS4dFKO2HMvac57K9JOQluLuEa6ntZHF19J2fd2zJl9y7
 Huv98I55r9_8gVZLnxnEtBWkGO_vUf8ZVnWAlOFO0VplB8uR_IC3Wtyw.Eq1
 eYO6rLZf96Dv9vcO73lccZcN9dloKD52knUD1UDAzuK8CLoXU_ublnurqJ_5
 scnRdpJpTh_bu5PevPGS3FvgppWVmVHo-
X-Rocket-MIMEInfo: 002.001,Pk9uIFNhdHVyZGF5LCBNYXJjaCAxNSwgMjAxNCAxOjU1IEFNLCBMZXZlbnRlIEt1cnVzYSA8bGV2ZXhAbGludXguY29tPiB3cm90ZToKCj4.T24gMDMvMTUvMjAxNCAwNDozMCBBTSwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgo.Pj4gT24gRnJpZGF5LCBNYXJjaCAxNCwgMjAxNCAxMTo0NyBBTSwgTGV2ZW50ZSBLdXJ1c2EgPGxldmV4QGxpbnV4LmNvbT4gd3JvdGU6Cj4.PsKgCj4.PkNhbGwga2ZyZWUoKSBvbiBiZGV2LiBUaGUgdmFyaWFibGUgaXMgb3RoZXJ3aXNlIGxlYWtlZC4KPj4.Cj4.PlNpZ25lZC1vZmYBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.178.641
References: <1394813775-12363-1-git-send-email-levex@linux.com> <1394854216.83246.YahooMailNeo@web164002.mail.gq1.yahoo.com> <5323F944.2040400@linux.com>
Message-ID: <1394868089.38574.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Sat, 15 Mar 2014 00:21:29 -0700 (PDT)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] staging: comedi: fix memory leak
To: Levente Kurusa <levex@linux.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        OSUOSL Drivers <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <5323F944.2040400@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Saturday, March 15, 2014 1:55 AM, Levente Kurusa <levex@linux.com> wrote:

>>On 03/15/2014 04:30 AM, Chase Southwood wrote:
>>> On Friday, March 14, 2014 11:47 AM, Levente Kurusa <levex@linux.com> wrote:
>>> 
>>>Call kfree() on bdev. The variable is otherwise leaked.
>>>
>>>Signed-off-by: Levente Kurusa <levex@linux.com>
>>>[...]
>>>
>>
>>
>>Levente,
>>
>>This change has already been made in staging-next (by me, actually :) ).  In
>>order to avoid re-doing work which has already been done, please make sure to base
>>all of your patches off of linux-next (or for staging, staging-next).
>>
>>Thanks,
>>Chase
>>
>
>Ah, yes I see now. I wonder how it didn't reach my tree.
>Anyways, thanks for the heads up!
>
>-- 
>Regards,
>Levente Kurusa


No problem, just wanted to make sure you were working from an up-to-date tree :)

Thanks,
Chase
