Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964832AbaCSQhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:37:12 -0400
Received: from relais.videotron.ca ([24.201.245.36]:52536 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374AbaCSQhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:37:10 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_n48gUnlOLpW4D2TOtnel7g)"
Date: Wed, 19 Mar 2014 12:37:09 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mvsdio: unhandled interrupt, mmc writes queuing up
In-reply-to: <20140319162832.1f5caae0@neptune.home>
Message-id: <alpine.LFD.2.11.1403191221310.1291@knanqh.ubzr>
References: <20140319162832.1f5caae0@neptune.home>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Content-id: <alpine.LFD.2.11.1403191222250.1291@knanqh.ubzr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_n48gUnlOLpW4D2TOtnel7g)
Content-id: <alpine.LFD.2.11.1403191222251.1291@knanqh.ubzr>
Content-type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-transfer-encoding: 8BIT

On Wed, 19 Mar 2014, Bruno Prémont wrote:

> Hi,
> 
> Since upgrading my Sheevaplug from 3.7.2 to 3.13.6 (FDT) I'm seeing
>   mvsdio f1090000.mvsdio: unhandled interrupt status=0x8810 en=0x0000 pio=0
> at varied timings.

It has been many years since I've looked at the code for this driver.  
I'm therefore including Thomas Petazzoni to the CC list as he appears to 
have been the most active since then.

The reported status seems to indicate missing data in the context of a 
transfer with CMD12, and a CRC error ensued of course.

At this point I'd suggest testing intermediate kernels between 3.7 and 
3.13, and try bisection until you find the offending commit.

[...]
> I get same results with 3.14-rc7.

Excellent, that reduces the search space significantly.  You can do a 
git bisect directly.


Nicolas

--Boundary_(ID_n48gUnlOLpW4D2TOtnel7g)--
