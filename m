Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432AbaC1Xi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 19:38:58 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38589 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaC1Xi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 19:38:56 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC 5/5] tty: Update hypervisor tty drivers to use core stdout parsing code.
To: Olof Johansson <olof@lixom.net>
Cc: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
        rob.herring@linaro.org
In-Reply-To: <20140328185443.GA26433@quad.lixom.net>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org> < 1396022885-6102-6-git-send-email-grant.likely@linaro.org> <20140328185443. GA26433@quad.lixom.net>
Date: Fri, 28 Mar 2014 14:41:35 -0700
Message-Id: <20140328214135.36027C41FF4@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2014 11:54:43 -0700, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Mar 28, 2014 at 09:08:05AM -0700, Grant Likely wrote:
> > diff --git a/drivers/tty/ehv_bytechan.c b/drivers/tty/ehv_bytechan.c
> > index 0419b69e270f..4f485e88f60c 100644
> > --- a/drivers/tty/ehv_bytechan.c
> > +++ b/drivers/tty/ehv_bytechan.c
> > @@ -108,55 +108,23 @@ static void disable_tx_interrupt(struct ehv_bc_data *bc)
> >   *
> >   * The byte channel to be used for the console is specified via a "stdout"
> >   * property in the /chosen node.
> > - *
> > - * For compatible with legacy device trees, we also look for a "stdout" alias.
> >   */
> 
> Did you mean to remove this /aliases/stdout checking? Based on the comment it
> seems that some older device trees / platforms might rely on it?

I moved it to the common code.

> > diff --git a/drivers/tty/hvc/hvc_opal.c b/drivers/tty/hvc/hvc_opal.c
> > index b01659bd4f7c..0ec1a80dd6a2 100644
> > --- a/drivers/tty/hvc/hvc_opal.c
> > +++ b/drivers/tty/hvc/hvc_opal.c
> > @@ -322,22 +322,14 @@ static void udbg_init_opal_common(void)
> >  
> >  void __init hvc_opal_init_early(void)
> >  {
> > -	struct device_node *stdout_node = NULL;
> > +	struct device_node *stdout_node = of_node_get(of_stdout);
> >  	const __be32 *termno;
> >  	const char *name = NULL;
> 
> Name is no longer used, should be removed.

Fixed, thanks.

g.
