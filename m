Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaHVU5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 16:57:22 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:44459 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaHVU5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 16:57:20 -0400
Message-ID: <53F7AEAC.90303@gmail.com>
Date: Fri, 22 Aug 2014 13:57:16 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Florian Fainelli <f.fainelli@gmail.com>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Kumar Gala <galak@codeaurora.org>, Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>, Rob Herring <robh+dt@kernel.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, John Crispin <blogic@openwrt.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jayachandran C <jchandra@broadcom.com>,
        Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 0/7] MIPS: Move device-tree files to a common location
References: <1408651466-8334-1-git-send-email-abrestic@chromium.org> <CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com>
In-Reply-To: <CAGVrzcZobuL4z0WNX+Sz4p_uwaPL-S5yvEmgRUwZPJi4+qq0tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 01:42 PM, Florian Fainelli wrote:
> On Aug 21, 2014 3:05 PM, "Andrew Bresticker" <abrestic@chromium.org
> <mailto:abrestic@chromium.org>> wrote:
>  >
>  > To be consistent with other architectures and to avoid unnecessary
>  > makefile duplication, move all MIPS device-trees to arch/mips/boot/dts
>  > and build them with a common makefile.
>
> I recall reading that the ARM organization for DTS files was a bit
> unfortunate and should have been something like:
>
> arch/arm/boot/dts/<vendor>/
>
> Is this something we should do for the MIPS and update the other
> architectures to follow that scheme?

If we choose not to intermingle .dts files from all the vendors in a 
single directory, why do anything at all?  Currently the .dts files for 
a vendor are nicely segregated with the rest of the vendors code under a 
single directory.

Personally I think things are fine as they are.  Any common code 
remaining in the Makefiles could be moved to the scripts directory for a 
smaller change.


>
>  >
>  > Patch 1 sets up the makefiles for building the DTs in arch/mips/boot/dts
>  > and introduces the config option BUILTIN_DTB for platforms that require
>  > it.
>  >
>  > Patch 2 introduces the 'dtbs' makefile target to allow building of just
>  > the DT binaries.
>  >
>  > Patches 3-7 move the DTs out of the platform directores.
>  >
>  > I've build tested this on all affected platforms (Octeon, Lantiq, SEAD3,
>  > Netlogic, and Ralink) as well as Malta.  For platforms where builtin DTBs
>  > are optional (Netlogic and Ralink), I built with and without the builtin
>  > DTBs.
>  >
>  > Based on 3.17-rc1.
>  >
>  > Andrew Bresticker (7):
>  >   MIPS: Create common infrastructure for building built-in device-trees
>  >   MIPS: Add support for building device-tree binaries
>  >   MIPS: Octeon: Move device-trees to arch/mips/boot/dts/
>  >   MIPS: Lantiq: Move device-trees to arch/mips/boot/dts/
>  >   MIPS: sead3: Move device-trees to arch/mips/boot/dts/
>  >   MIPS: Netlogic: Move device-trees to arch/mips/boot/dts/
>  >   MIPS: ralink: Move device-trees to arch/mips/boot/dts/
>  >
>  >  arch/mips/Kconfig                                    |  5 +++++
>  >  arch/mips/Makefile                                   | 11 +++++++++++
>  >  arch/mips/boot/.gitignore                            |  1 +
>  >  arch/mips/boot/dts/Makefile                          | 20
> ++++++++++++++++++++
>  >  arch/mips/{lantiq => boot}/dts/danube.dtsi           |  0
>  >  arch/mips/{lantiq => boot}/dts/easy50712.dts         |  0
>  >  arch/mips/{ralink => boot}/dts/mt7620a.dtsi          |  0
>  >  arch/mips/{ralink => boot}/dts/mt7620a_eval.dts      |  0
>  >  .../mips/{cavium-octeon => boot/dts}/octeon_3xxx.dts |  0
>  >  .../mips/{cavium-octeon => boot/dts}/octeon_68xx.dts |  0
>  >  arch/mips/{ralink => boot}/dts/rt2880.dtsi           |  0
>  >  arch/mips/{ralink => boot}/dts/rt2880_eval.dts       |  0
>  >  arch/mips/{ralink => boot}/dts/rt3050.dtsi           |  0
>  >  arch/mips/{ralink => boot}/dts/rt3052_eval.dts       |  0
>  >  arch/mips/{ralink => boot}/dts/rt3883.dtsi           |  0
>  >  arch/mips/{ralink => boot}/dts/rt3883_eval.dts       |  0
>  >  arch/mips/{mti-sead3 => boot/dts}/sead3.dts          |  0
>  >  arch/mips/{netlogic => boot}/dts/xlp_evp.dts         |  0
>  >  arch/mips/{netlogic => boot}/dts/xlp_fvp.dts         |  0
>  >  arch/mips/{netlogic => boot}/dts/xlp_gvp.dts         |  0
>  >  arch/mips/{netlogic => boot}/dts/xlp_svp.dts         |  0
>  >  arch/mips/cavium-octeon/.gitignore                   |  2 --
>  >  arch/mips/cavium-octeon/Makefile                     | 10 ----------
>  >  arch/mips/lantiq/Kconfig                             |  1 +
>  >  arch/mips/lantiq/Makefile                            |  2 --
>  >  arch/mips/lantiq/dts/Makefile                        |  1 -
>  >  arch/mips/mti-sead3/Makefile                         |  4 ----
>  >  arch/mips/netlogic/Kconfig                           |  4 ++++
>  >  arch/mips/netlogic/Makefile                          |  1 -
>  >  arch/mips/netlogic/dts/Makefile                      |  4 ----
>  >  arch/mips/ralink/Kconfig                             |  4 ++++
>  >  arch/mips/ralink/Makefile                            |  2 --
>  >  arch/mips/ralink/dts/Makefile                        |  4 ----
>  >  33 files changed, 46 insertions(+), 30 deletions(-)
>  >  create mode 100644 arch/mips/boot/dts/Makefile
>  >  rename arch/mips/{lantiq => boot}/dts/danube.dtsi (100%)
>  >  rename arch/mips/{lantiq => boot}/dts/easy50712.dts (100%)
>  >  rename arch/mips/{ralink => boot}/dts/mt7620a.dtsi (100%)
>  >  rename arch/mips/{ralink => boot}/dts/mt7620a_eval.dts (100%)
>  >  rename arch/mips/{cavium-octeon => boot/dts}/octeon_3xxx.dts (100%)
>  >  rename arch/mips/{cavium-octeon => boot/dts}/octeon_68xx.dts (100%)
>  >  rename arch/mips/{ralink => boot}/dts/rt2880.dtsi (100%)
>  >  rename arch/mips/{ralink => boot}/dts/rt2880_eval.dts (100%)
>  >  rename arch/mips/{ralink => boot}/dts/rt3050.dtsi (100%)
>  >  rename arch/mips/{ralink => boot}/dts/rt3052_eval.dts (100%)
>  >  rename arch/mips/{ralink => boot}/dts/rt3883.dtsi (100%)
>  >  rename arch/mips/{ralink => boot}/dts/rt3883_eval.dts (100%)
>  >  rename arch/mips/{mti-sead3 => boot/dts}/sead3.dts (100%)
>  >  rename arch/mips/{netlogic => boot}/dts/xlp_evp.dts (100%)
>  >  rename arch/mips/{netlogic => boot}/dts/xlp_fvp.dts (100%)
>  >  rename arch/mips/{netlogic => boot}/dts/xlp_gvp.dts (100%)
>  >  rename arch/mips/{netlogic => boot}/dts/xlp_svp.dts (100%)
>  >  delete mode 100644 arch/mips/cavium-octeon/.gitignore
>  >  delete mode 100644 arch/mips/lantiq/dts/Makefile
>  >  delete mode 100644 arch/mips/netlogic/dts/Makefile
>  >  delete mode 100644 arch/mips/ralink/dts/Makefile
>  >
>  > --
>  > 2.1.0.rc2.206.gedb03e5
>  >
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe devicetree" in
>  > the body of a message to majordomo@vger.kernel.org
> <mailto:majordomo@vger.kernel.org>
>  > More majordomo info at http://vger.kernel.org/majordomo-info.html
>

