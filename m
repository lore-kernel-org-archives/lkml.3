Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbaJBTcA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:32:00 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:50376 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753006AbaJBTb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:31:57 -0400
Message-ID: <1412278315.6504.6.camel@x41>
Subject: Re: cehckpatch config symbol description false positive
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 02 Oct 2014 21:31:55 +0200
In-Reply-To: <CAMuHMdWc1X3Jiw3zFs2GsqXKxg-Ti_5fPOSk+DsyUwjvikwz+g@mail.gmail.com>
References: <CAMuHMdWc1X3Jiw3zFs2GsqXKxg-Ti_5fPOSk+DsyUwjvikwz+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2014 19:31:55.0773 (UTC) FILETIME=[8699BAD0:01CFDE77]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven schreef op do 02-10-2014 om 21:08 [+0200]:
> When running checkpatch on
> http://marc.info/?l=linux-sh&m=141227657322649&w=2
> I get a false positive about the Kconfig symbol I just introduced, incl. a help
> text:
> 
> WARNING: please write a paragraph that describes the config symbol fully
> #60: FILE: arch/arm/Kconfig.debug:702:
> + config DEBUG_SCIF

When you add one single line to your help (say, "Bla bla.") the warning
disappears. So you hit this test:
    "please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($is_start && $is_end && $length < 4);

because the paragraph was just three lines. It seems a length of one,
two, or three lines can be OK. It depends. Perhaps the test should just
be:
    [...] && $length);


Paul Bolle

