Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbaGHPzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 11:55:00 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:60095 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbaGHPy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 11:54:58 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 0/3] Support for Qualcomm QPNP PMIC's
Date: Tue,  8 Jul 2014 18:54:26 +0300
Message-Id: <1404834869-23049-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to all,

Here is patch set which adds Qualcomm QPNP PMIC's support.
I've removed RFC tag and sending as regular set hoping that
this time more comments will come out. The link to the RFCv2
at [1].

The first patch in the set implements an *of* based parsing of
PMIC peripheral resources and adding mfd cell for it.
The devicetree node should contain a compatible and reg
proparties. The intention was to keep things simple and similar
to the other mfd drivers. 

The second patch adds binding document for qpnp-spmi.

The third patch describes the devicetree binding of the slave
devices attached to the SPMI interface. 

Comments are welcome.

regards,
Stan

[1] https://lkml.org/lkml/2014/7/3/443

Ivan T. Ivanov (2):
  mfd: qpnp-spmi: document DT bindings for Qualcomm QPNP PMICs
  dt: qcom: msm8974: add qpnp-spmi device nodes

Josh Cartwright (1):
  mfd: qpnp-spmi: add support for Qualcomm QPNP PMICs

 .../devicetree/bindings/qpnp/qcom,qpnp-spmi.txt    |   53 +++++++
 arch/arm/boot/dts/qcom-msm8974.dtsi                |   45 ++++++
 drivers/mfd/Kconfig                                |   15 ++
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/qpnp-spmi.c                            |  145 ++++++++++++++++++++
 5 files changed, 259 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/qpnp/qcom,qpnp-spmi.txt
 create mode 100644 drivers/mfd/qpnp-spmi.c

