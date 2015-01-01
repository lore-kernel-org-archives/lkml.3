Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbbAAUks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 15:40:48 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:53772 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbbAAUkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 15:40:46 -0500
Date: Thu, 1 Jan 2015 21:40:45 +0100
From: Andreas Mohr <andi@lisas.de>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "crmafra@gmail.com" <crmafra@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andreas.noever@gmail.com" <andreas.noever@gmail.com>,
        "crmafra2@gmail.com" <crmafra2@gmail.com>, rafael.j.wysocki@intel.com
Subject: Re: Bisected regression from 3.17 still present in 3.19-rc1
Message-ID: <20150101204045.GA14006@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419939412.25226.2.camel@nebula.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> There's your problem. The Darwin call results in the firmware exposing
> the battery via SBS, not as an ACPI control method battery. Enable
> CONFIG_ACPI_SBS and you should be good.

Hmm, do I smell a possible usability case here?
Two choices:
a) declare a non-CONFIG_ACPI_SBS kernel
   to be a "broken/inconsistent configuration"
   (e.g. when used with a "Darwin" personality)
   which thus will "simply not work"
   (--> limitation is "by design"),
   thus simply give up
b) declare CONFIG_ACPI_SBS to be cleanly optional/dynamic,
   and then in case missing CONFIG_ACPI_SBS happens to be requested
   try to give hints that it is missing

a) may easily be fully acceptable, but if b) is deemed better,
then perhaps there are ways
(such as failing calls --> generate log error message, ...)
to nicely determine/diagnose/report this issue.

Andreas Mohr
