Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaAIBg5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 20:36:57 -0500
Received: from gate.crashing.org ([63.228.1.57]:41791 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaAIBgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 20:36:53 -0500
Message-ID: <1389231387.4672.50.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix alignment of secondary cpu spin vars
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Olof Johansson <olof@lixom.net>
Cc: Michael Ellerman <michael@ellerman.id.au>, chzigotzky@xenosoft.de,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>
Date: Thu, 09 Jan 2014 12:36:27 +1100
In-Reply-To: <20140108174828.GA16830@quad.lixom.net>
References: <1388264507-5100-1-git-send-email-olof@lixom.net>
	 <CAOesGMhHw-G-T7ZfNsVU92ftOucCNe9shNJtA7SWzqX=dQBQng@mail.gmail.com>
	 <CAOesGMgsY0R6KBXXH_ibTBYb1i_auWESwnoDkvi-esb58Pc+2A@mail.gmail.com>
	 <20140103081219.GA10233@quad.lixom.net> <1389154189.2076.5.camel@concordia>
	 <1389154706.4672.21.camel@pasglop> <20140108174828.GA16830@quad.lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-08 at 09:48 -0800, Olof Johansson wrote:

> >         /* If it's a display, note it */
> > -       memset(type, 0, sizeof(type));
> > -       prom_getprop(stdout_node, "device_type", type, sizeof(type));
> > -       if (strcmp(type, "display") == 0)
> > -               prom_setprop(stdout_node, path, "linux,boot-display", NULL, 0);
> > +       stdout_node = call_prom("instance-to-package", 1, 1, prom.stdout);
> > +       if (stdout_node != PROM_ERROR) {
> > +               val = cpu_to_be32(stdout_node);
> > +               memset(type, 0, sizeof(type));
> > +               prom_getprop(stdout_node, "device_type", type, sizeof(type));
> > +               if (strcmp(type, "display") == 0)
> > +                       prom_setprop(stdout_node, path, "linux,boot-display", NU
> 
> Line is cut off, this needs "NULL, 0);" at the end.

Right, copy/paste failure :-)

Thanks, I'll try to get that to Linus before he cuts .13, otherwise it
will be -stable.

Cheers,
Ben.


