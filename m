Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbaEHRe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:34:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23304 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571AbaEHRe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:34:27 -0400
X-AuditID: cbfee61b-b7f766d00000646c-59-536bc021f720
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH V2 0/4] Exynos4 SoC camera subsystem driver cleanups
Date: Thu, 08 May 2014 19:34:07 +0200
Message-id: <1399570448-29737-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xoK7Sgexgg6VdTBbzj5xjtTjb9Ibd
	YtPja6wWl3fNYbPo2bCV1WLp9YtMFq17j7BbHH7TzurA4bFm3hpGj02rOtk8Ni+p9+jbsorR
	4/MmuQDWKC6blNSczLLUIn27BK6MnSueMBWs4arY9+0mUwPjdI4uRk4OCQETiYOvFrBA2GIS
	F+6tZ+ti5OIQEpjOKLH31G1WCKeDSeLP5QZWkCo2AUOJ3qN9jCC2iIC8xJPeG2AdzAI3GCXW
	tPxlAkkIC7hInL3+G8xmEVCVWLHnBNgKXgE3iaamV0DNHEDrFCTmTLKZwMi9gJFhFaNoakFy
	QXFSeq6RXnFibnFpXrpecn7uJkZwuDyT3sG4qsHiEKMAB6MSD++LKdnBQqyJZcWVuYcYJTiY
	lUR4XywDCvGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamAU
	C98X0KvM9F+j3rNL4NPsPX1nGhI3z+u4f+bdr+vJWvGczYeW184q0NTRmfeK1bDon3PYhCs+
	uzkvfD8v5XHT+pt0nEDIFK0zZZvzeljsnjQUqf64f35lyT2xJjbf493Vv4R5vU6YX/l8ZIGQ
	48nd3BPnX733oIaDkT3p4DHHDdYf0zfL7w1XYinOSDTUYi4qTgQAhbBqExMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series includes some bug fixes for the Exynos4/S5P SoC camera
interface drivers and removes (ab)use of "simple-bus" compatible string.

Comparing to previous version I've excluded patches dropping support
for non-dt platforms and added two further bug fixes.
of_platform_populate() is used instead of manually parsing the device
tree and creating devices and the cleanup function has been moved to
the core. This series depends on patch:
http://www.kernelhub.org/?msg=466319&p=2

Sylwester Nawrocki (4):
  exynos4-is: Free FIMC-IS CPU memory only when allocated
  exynos4-is: Move firmware request to subdev open()
  exynos4-is: Remove requirement for "simple-bus" compatible
  ARM: dts: exynos4: Remove simple-bus compatibles from the camera
    subsystem

 .../devicetree/bindings/media/samsung-fimc.txt     |    6 +--
 arch/arm/boot/dts/exynos4.dtsi                     |    2 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |    2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |   50 ++++++++++----------
 drivers/media/platform/exynos4-is/fimc-is.h        |    2 +-
 drivers/media/platform/exynos4-is/fimc-isp.c       |   10 +++-
 drivers/media/platform/exynos4-is/media-dev.c      |   21 ++++++--
 7 files changed, 58 insertions(+), 35 deletions(-)

--
1.7.9.5

