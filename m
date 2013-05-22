Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982Ab3EVTre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:47:34 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:32834 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3EVTrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:47:33 -0400
MIME-Version: 1.0
In-Reply-To: <20130522191551.GB10617@phenom.dumpdata.com>
References: <1365692161-13735-1-git-send-email-dgdegra@tycho.nsa.gov> <20130522191551.GB10617@phenom.dumpdata.com>
From: Kent Yoder <shpedoikal@gmail.com>
Date: Wed, 22 May 2013 14:47:01 -0500
Message-ID: <CAM0nabGSo9b7q1pGOsTGjFzJBi7cK=2s5mGmOgNjeAf-2+ZvDQ@mail.gmail.com>
Subject: Re: [tpmdd-devel] [PATCH v2] drivers/tpm: add xen tpmfront interface
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        leosilva@linux.vnet.ibm.com, adlai@linux.vnet.ibm.com
Cc: Daniel De Graaf <dgdegra@tycho.nsa.gov>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
        Ian.Campbell@citrix.com, Jan Beulich <JBeulich@suse.com>,
        xen-devel@lists.xen.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +     notify_remote_via_evtchn(priv->evtchn);
>> +
>> +     ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
>
> Um, + 6? Why? Is there an #define for that magic constant?
> Should this value be read before you do the wait_for_tpm_stat stuff?

  This is hardcoded to 6 even in tpm.c.  Time for a #define...

> Otherwise it looks OK to me. Should this go through me or Kent?
> And if so, is Kent waiting for my feedback?

  My comments were minor -- I was expecting feedback on your earlier
comments before merging.  I think this should go through the tpmdd
maintainer if its going to live in drivers/char/tpm though.

Kent

> ------------------------------------------------------------------------------
> Try New Relic Now & We'll Send You this Cool Shirt
> New Relic is the only SaaS-based application performance monitoring service
> that delivers powerful full stack analytics. Optimize and monitor your
> browser, app, & servers with just a few lines of code. Try New Relic
> and get this awesome Nerd Life shirt! http://p.sf.net/sfu/newrelic_d2d_may
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel
