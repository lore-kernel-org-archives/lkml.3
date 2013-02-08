Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947064Ab3BHWEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:04:54 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:35311 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946953Ab3BHWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:04:53 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V8] kbuild: create a rule to run the pre-processor on *.dts files
To: Rob Herring <robherring2@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Michal Marek <mmarek@suse.cz>,
        Grant Likely <glikely@secretlab.ca>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Scott Wood <scottwood@freescale.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
In-Reply-To: <51156D09.7060401@gmail.com>
References: <1360091188-24063-1-git-send-email-swarren@wwwdotorg.org> <20130208144527.0D8DD3E2C01@localhost> <51156D09.7060401@gmail.com>
Date: Fri, 08 Feb 2013 22:04:48 +0000
Message-Id: <20130208220448.EDA773E2C27@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Feb 2013 15:24:25 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On 02/08/2013 08:45 AM, Grant Likely wrote:
> > On Tue,  5 Feb 2013 12:06:28 -0700, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> Create cmd_dtc_cpp to run the C pre-processor on *.dts file before
> >> passing them to dtc for final compilation. This allows the use of #define
> >> and #include within the .dts file.
> >>
> >> Acked-by: Simon Glass <sjg@chromium.org>
> >> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> >> Acked-by: Michal Marek <mmarek@suse.cz>
> >> Acked-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> >> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> > 
> > I've applied this and was going to push it out, but I've just thought of
> > a problem that could be a show stopper. Once a dtsp file includes a C
> > header, the contents of that header become part of the Device Tree ABI.
> > If someone changes that file (ie. to renumber a series of #defines) then
> > that will break the binding. We need a way to protect against that.
> > Someone changing a .h file may make the assumption that it is only
> > kernel internal and won't realize that it has external implications.
> > 
> > I'm thinking that any dts includes need to be treated in the same way as
> > userspace headers. We could put them into include/uapi and piggy back on
> > the protection already afforded by that directory, or come up with
> > something new. Any thoughts?
> 
> Also, we would never be able to separate the dts files from the kernel
> tree without some separation.

Good point. They better be in a completely separate directory then.

g.

