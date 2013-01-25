Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3AYRTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 12:19:35 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:18871 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab3AYRTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 12:19:31 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGji0LFus=
X-RZG-CLASS-ID: mo00
Date: Fri, 25 Jan 2013 18:19:23 +0100
From: Olaf Hering <olaf@aepfle.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jan Beulich (JBeulich@suse.com)" <JBeulich@suse.com>
Subject: Re: [PATCH] x86: Hyper-V: register clocksource only if its advertised
Message-ID: <20130125171923.GA19306@aepfle.de>
References: <1359121036-16309-1-git-send-email-olaf@aepfle.de>
 <761b736ff1854810bfe272961248e6d2@BLUPR03MB050.namprd03.prod.outlook.com>
 <20130125165443.GA15833@aepfle.de>
 <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <500ca90f5d3e4d4f80c7fb62c34d36f0@BLUPR03MB050.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21.rev5632 (2013-01-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, KY Srinivasan wrote:

> My fear is that there is no guarantee that Xen would not emulate this
> feature in the spirit of making Hyper-V emulation "more" complete.
> Since all this problem is because Xen thinks it is running a viridian
> domain (when in fact it is running Linux), I felt we should explore
> why the viridian tag got set for a Linux VM. If we can fix that we
> would have a solution that does not depend upon assuming that Xen
> would not emulate a particular Hyper-V feature.

In my opinion this logic is backwards. A host provides a set of
functionality/features to a given guest, no matter what runs inside the
guest. And the guest can query the feature list and configure itself
accordingly. In this specific case the guest finds feature A (the cpuid
result) and expects that feature B (a clock source) is present as well,
even if feature B has its very own availability flag.

Maybe I miss your point.

Olaf
