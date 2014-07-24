Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbaGXMqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:46:08 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:54444 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbaGXMqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:46:05 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH v3 0/4] Support for Qualcomm QPNP PMIC's
Date: Thu, 24 Jul 2014 15:45:17 +0300
Message-Id: <1406205921-7452-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Changes since v2:
 - 1/4 - added new line, signed-off-by / acked-by and module_authors.
 - 3/4 - the subject has been changed.

The previous v2 can be found at [1].

I'm still waiting Acks for:
 - 4/4 from Qualcomm folks.
 - 2/4 and 3/4 from DT folks.

The patchset is ready to merge version and also it can be treated as an
intermediate step until we find a solution for non-translatable peripheral
addresses.

regards,
Stan

[1] https://lkml.org/lkml/2014/7/17/877

--------------------------------------------------------------------------------

Hello everyone,

Here is the continuation of patch sets sent recently about Qualcomm
QPNP SPMI PMICs.

The previous version of the patch set can be found at [1].

Changes since v1:
 - removed completely custom *of* parser
 - renamed the mfd driver from qpnp-spmi to pm8xxx-spmi
 - now MFD_PM8XXX_SPMI Kconfig option depends on SPMI

Removing of the custom *of* parser leads to that that the *reg* devicetree
property cannot exist and therefore cannot be parsed to get PMIC peripheral
resources. I took this step aside because no one from mfd drivers does this
parsing. This will lead to inconvenience in the peripheral drivers to define
internally the SPMI base addresses depending on the compatible property
i.e. PMIC version. 

Comments are welcome!

[1] https://lkml.org/lkml/2014/7/8/428

Josh Cartwright (1):
  mfd: pm8xxx-spmi: add support for Qualcomm SPMI PMICs

Stanimir Varbanov (3):
  mfd: pm8xxx-spmi: document DT bindings for Qualcomm SPMI PMICs
  ARM: dts: qcom: add pm8941 and pm8841 PMICs device nodes
  mfd: pm8921: rename pm8921-core driver

 .../devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt   |   49 +++++++++++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   37 +++++++++++
 drivers/mfd/Kconfig                                |   30 +++++++--
 drivers/mfd/Makefile                               |    3 +-
 drivers/mfd/pm8xxx-spmi.c                          |   65 ++++++++++++++++++++
 drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c}       |   38 ++++++------
 6 files changed, 195 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/qcom,pm8xxx-spmi.txt
 create mode 100644 drivers/mfd/pm8xxx-spmi.c
 rename drivers/mfd/{pm8921-core.c => pm8xxx-ssbi.c} (92%)

