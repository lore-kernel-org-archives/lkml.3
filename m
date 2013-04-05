Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162366Ab3DERyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:54:39 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:62194 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162346Ab3DERyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:54:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAGbaURnvzRm3N7++3p6G4U9eb_US6hBYCYQrEHs=FeZ+Gk9qEw@mail.gmail.com>
References: <CAGbaURnvzRm3N7++3p6G4U9eb_US6hBYCYQrEHs=FeZ+Gk9qEw@mail.gmail.com>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 5 Apr 2013 14:54:16 -0300
Message-ID: <CAMOw1v4aHTOr_a9FBFuQXfLGq1SVNWiWnYn-xn-mG+gQWEeiNQ@mail.gmail.com>
Subject: Re: control on cpu/core
To: christophe malvasio <arsdmthe@gmail.com>
Cc: linux-modules <linux-modules@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 1:30 PM, christophe malvasio <arsdmthe@gmail.com> wrote:
> hi all
> i want to give the control of one core to a module
> that is the kernel have to not schedule/interrupt execution on this
> core and also my module have to be the only thing to send execution on
> this core
> i'm not sure if i can make it only from my module or if i must hack
> the kernel too ?
> fake core unplug or more coding ?
> give me your opinion ;)

You can isolate a core during boot so no process is scheduled to that
core. See "isolcpus=" in Documentation/kernel-parameters.txt.

I don't know what your module is doing so it might not be possible in
all scenarios. The only way I see is if your module created a kernel
thread. Then it can be moved to the isolated core by setting the cpu
mask. See for example how kworker, watchdog, migration do.

I'm CCing LKML to broaden your audience. linux-modules@vger.kernel.org
is really low traffic and mostly intended for the module
loading/removal process, not really about writing modules.


Lucas De Marchi
