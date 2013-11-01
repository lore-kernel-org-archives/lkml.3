Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3KALqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:46:20 -0400
Received: from 12.mo6.mail-out.ovh.net ([178.32.125.228]:45193 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799Ab3KALqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:46:19 -0400
X-Greylist: delayed 109050 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Nov 2013 07:46:18 EDT
Date: Fri, 1 Nov 2013 12:10:20 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        James Bates <james.h.bates@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        James Bates <james.h.bates@yahoo.com>
Subject: Re: [PATCH v2] efifb: prevent null-deref when iterating dmi_list
Message-ID: <20131101111020.GD18477@ns203013.ovh.net>
References: <1380732056-5387-1-git-send-email-dh.herrmann@gmail.com>
 <20131031104549.GZ18477@ns203013.ovh.net>
 <CANq1E4QAwOG8Vdw2nCb8+LirZ278w58j+wpieeKvnNepga+baw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4QAwOG8Vdw2nCb8+LirZ278w58j+wpieeKvnNepga+baw@mail.gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 10043308646135475149
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrgeelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:17 Thu 31 Oct     , David Herrmann wrote:
> Hi
> 
> On Thu, Oct 31, 2013 at 11:45 AM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com> wrote:
> > On 18:40 Wed 02 Oct     , David Herrmann wrote:
> >> The dmi_list array is initialized using gnu designated initializers, and
> >> therefore may contain fewer explicitly defined entries as there are
> >> elements in it. This is because the enum above with M_xyz constants
> >> contains more items than the designated initializer. Those elements not
> >> explicitly initialized are implicitly set to 0.
> >>
> >> Now efifb_setup() loops through all these array elements, and performs
> >> a strcmp on each item. For non explicitly initialized elements this will
> >> be a null pointer:
> >>
> >> This patch swaps the check order in the if statement, thus checks first
> >> whether dmi_list[i].base is null.
> >>
> >> Signed-off-by: James Bates <james.h.bates@yahoo.com>
> >> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> >
> > with the simpleDRM arriving next merge I'm wondering if we need to keep it?
> 
> SimpleDRM is not coming next merge-window. It's basically finished,
> but I'm still working on the user-space side as its KMS api is highly
> reduced compared to fully-featured DRM/KMS drivers. Maybe 3.13 will
> work out.

do you have a git tree for the simpleDRM that I can pull?
> 
> Anyhow, this patch is still needed as it fixes a serious bug for simplefb.

ok
> 
> Thanks
> David
