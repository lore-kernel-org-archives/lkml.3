Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaA3WRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:17:32 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:63331 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaA3WRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:17:30 -0500
Date: Thu, 30 Jan 2014 14:17:28 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Randy Dunlap <rdunlap@infradead.org>
cc: Andiry Xu <andiry@gmail.com>, linux-kernel@vger.kernel.org,
        Andiry Xu <andiry.xu@gmail.com>, Linux MM <linux-mm@kvack.org>
Subject: Re: [BUG] Description for memmap in kernel-parameters.txt is wrong
In-Reply-To: <52EAB56E.2030102@infradead.org>
Message-ID: <alpine.DEB.2.02.1401301416030.15271@chino.kir.corp.google.com>
References: <CAOvWMLa334E8CYJLrHy6-0ZXBRneoMf-05v422SQw+dbGRubow@mail.gmail.com> <52EAA714.3080809@infradead.org> <CAOvWMLbs-sP+gJHV_5O6ZbV8eTpEKPVRVR238gFcPQeqhCjT3A@mail.gmail.com> <52EAB56E.2030102@infradead.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Randy Dunlap wrote:

> >>> Hi,
> >>>
> >>> In kernel-parameters.txt, there is following description:
> >>>
> >>> memmap=nn[KMG]$ss[KMG]
> >>>                         [KNL,ACPI] Mark specific memory as reserved.
> >>>                         Region of memory to be used, from ss to ss+nn.
> >>
> >> Should be:
> >>                           Region of memory to be reserved, from ss to ss+nn.
> >>
> >> but that doesn't help with the problem that you describe, does it?
> >>
> > 
> > Actually it should be:
> >                              Region of memory to be reserved, from nn to nn+ss.
> > 
> > That is, exchange nn and ss.
> 
> Yes, I understand that that's what you are reporting.  I just haven't yet
> worked out how the code manages to exchange those 2 values.
> 

It doesn't, the documentation is correct as written and could be improved 
by your suggestion of "Region of memory to be reserved, from ss to ss+nn."  
I think Andiry probably is having a problem with his bootloader 
interpreting the '$' incorrectly (or variable expansion if coming from the 
shell) or interpreting the resulting user-defined e820 map incorrectly.
