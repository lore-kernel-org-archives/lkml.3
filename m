Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799AbaLAWgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:36:41 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:60960 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbaLAWgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:36:39 -0500
Date: Mon, 1 Dec 2014 14:35:13 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Stefan Agner <stefan@agner.ch>
Cc: Feng Kan <fkan@apm.com>, mark.rutland@arm.com, shawn.guo@linaro.org,
        kernel@pengutronix.de, Arnd Bergmann <arnd@arndb.de>, sre@kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] power: reset: read priority from device tree
Message-ID: <20141201223513.GA32035@roeck-us.net>
References: <1417453389-1588-1-git-send-email-stefan@agner.ch>
 <1417453389-1588-2-git-send-email-stefan@agner.ch>
 <CAL85gmBq30pWxP0buKbM8so6QqsJq2YojiSK1EWtMPsH_7foeg@mail.gmail.com>
 <ea4f7a2bfdb9bea45cab9418c211083b@agner.ch>
 <CAL85gmBNE7oDbE+LX+V=AFJO61Ta0Gekoq6sDb8TkEnoPsNFVA@mail.gmail.com>
 <20141201174215.GB24692@roeck-us.net>
 <3916ca2867ced70e16903d6d44aaae8f@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3916ca2867ced70e16903d6d44aaae8f@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020208.547CED77.0057,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 14
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:18:47PM +0100, Stefan Agner wrote:
> On 2014-12-01 18:42, Guenter Roeck wrote:
> > On Mon, Dec 01, 2014 at 09:38:09AM -0800, Feng Kan wrote:
> >> On Mon, Dec 1, 2014 at 9:29 AM, Stefan Agner <stefan@agner.ch> wrote:
> >> > On 2014-12-01 18:15, Feng Kan wrote:
> >> >> On Mon, Dec 1, 2014 at 9:03 AM, Stefan Agner <stefan@agner.ch> wrote:
> >> >>> This patch adds an optional property which allows to specify the
> >> >>> reset source priority. This priority is used by the kernel restart
> >> >>> handler call chain to sort out the proper reset/restart method.
> >> >>> Depending on the power design of a board or other machine/board
> >> >>> specific peculiarity, it is not possible to pick a generic priority.
> >> >>>
> >> >>> Signed-off-by: Stefan Agner <stefan@agner.ch>
> >> >>> ---
> >> >>>  Documentation/devicetree/bindings/power/reset/syscon-reboot.txt | 3 +++
> >> >>>  drivers/power/reset/syscon-reboot.c                             | 5 ++++-
> >> >>>  2 files changed, 7 insertions(+), 1 deletion(-)
> >> >>>
> >> >>> diff --git a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> >>> index 1190631..ee41d9c 100644
> >> >>> --- a/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> >>> +++ b/Documentation/devicetree/bindings/power/reset/syscon-reboot.txt
> >> >>> @@ -11,6 +11,9 @@ Required properties:
> >> >>>  - offset: offset in the register map for the reboot register (in bytes)
> >> >>>  - mask: the reset value written to the reboot register (32 bit access)
> >> >>>
> >> >>> +Optional properties:
> >> >>> +- priority: define the priority of the reset (0-255, defaults to 128)
> >> >>> +
> >> >>>  Default will be little endian mode, 32 bit access only.
> >> >>>
> >> >>>  Examples:
> >> >>> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
> >> >>> index 815b901..3060d6b 100644
> >> >>> --- a/drivers/power/reset/syscon-reboot.c
> >> >>> +++ b/drivers/power/reset/syscon-reboot.c
> >> >>> @@ -67,8 +67,11 @@ static int syscon_reboot_probe(struct platform_device *pdev)
> >> >>>         if (of_property_read_u32(pdev->dev.of_node, "mask", &ctx->mask))
> >> >>>                 return -EINVAL;
> >> >>>
> >> >>> -       ctx->restart_handler.notifier_call = syscon_restart_handle;
> >> >>>         ctx->restart_handler.priority = 128;
> >> >>> +       of_property_read_u32(pdev->dev.of_node, "priority",
> >> >>> +                            &ctx->restart_handler.priority);
> >> >>
> >> >> What is this for?
> >> >
> >> > What do you mean? The moved line "ctx->restart_handler.notifier_call =
> >> > syscon_restart_handle;"? When one reads the diff, it looks like that
> >> > line was moved, in fact I tried to keep the of_property_read function
> >> > calls together. But I had to move the assignation of the default
> >> > priority in front of restart_handler.priority. That's what is the
> >> > outcome...
> >>
> >> I believe Guenter explained above already. Actually this help to solve one of
> >> my problem. Thanks.
> > 
> > Since Mark doesn't seem to be happy with the idea of making the priority
> > dt-configurable, the alternative might be to just set a higher priority for
> > syscon triggered resets, as suggested by Stefan. Not as flexible, but it
> > should be ok for most use cases.
> > 
> 
> I read the other branch of this thread too, but IMHO, this would be the
> best solution for now. It's a one line change and does the job. After
> all, we have that priority for a reason, it doesn't makes sense having
> all of them at a common default. As mentioned in an other reply, I think
> it is especially reasonable to configure the syscon-reboot driver a bit
> higher, since this driver is more likely to be used for a dedicated
> reboot feature provided by the SoC, which usually is the preferred one.
> If it happens one day that a SoC ends up with conflicting priorities or
> other priority odds, we can add the DT support then...
> 
> What do you think, can I go with that for now? (Guenter, Feng, Mark...?)
> 
Ok with me. After all, one only needs to remove the entry from the dt file
if not wanted/needed, so one could argue that its existence already implies
"preferred".

Guenter
