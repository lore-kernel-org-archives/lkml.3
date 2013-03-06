Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab3CFHy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:54:57 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53387 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab3CFHy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:54:56 -0500
X-AuditID: cbfee68d-b7f636d0000009be-2d-5136f64f5467
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 22/30] rtc: rtc-spear: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:54:54 +0900
Message-id: <009001ce1a3f$e3d015d0$ab704170$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAQsuQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ13/b2aBBk37mSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG0ymzglecFWtXrmdsYFzF0cXIySEhYCLROfsaC4QtJnHh3nq2
	LkYuDiGBZYwSrdvPsnYxcoAVrbluDhFfxChxtu0TVNFsJom+iwfYQLrZBNQkvnw5zA7SICKg
	L9HWogFSwyzQyyhxpnc3WFxIwFaiZx4PSDmngJ3ElImP2UFsYQEPicb955hBbBYBVYl3uw6y
	gti8QOUbn3RA2YISPybfAzuUWUBLYv3O40wQtrzE5jVvmSHuVJd49FcXJCwiYCQx59MJVogS
	EYl9L94xgpwjIbCIXeLV1DlMELsEJL5NPsQC0SsrsekAMyQcJCUOrrjBMoFRYhaSzbOQbJ6F
	ZPMsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJqt4djLcPWB9iTAZaP5FZSjQ5
	HxiVeSXxhsbGJmYmpibmlqbmpqQJK4nzyl2SCRQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	6OSybbFi+K0tPTui1VdoKnvNefTs0q8d2rfatqpfjD/HJDn9yQxD9YnRK2ckzhe9cUH5g+LC
	c9yGe354pYqdXLg1fRKP28f+k0F7dmnPEFdL6xNXutSssp5lu1hp2rsllQoMkslLvt2dp1Ox
	iXGV0q7aEyyJX57unyPsn/Xx3T8XxTNcM8XmuimxFGckGmoxFxUnAgD/A97BwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7fN7NAgxv3rCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRtMps4JXnBVrV65nbGBc
	xdHFyMEhIWAisea6eRcjJ5ApJnHh3nq2LkYuDiGBRYwSZ9s+QTmzmST6Lh5gA6liE1CT+PLl
	MDtIs4iAvkRbiwZIDbNAL6PEmd7dYHEhAVuJnnk8IOWcAnYSUyY+ZgexhQU8JBr3n2MGsVkE
	VCXe7TrICmLzApVvfNIBZQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIm9UlHv3VBQmLCBhJ
	zPl0ghWiRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpe
	cn7uJkZwzD6T3sG4qsHiEKMAB6MSD+8EFbNAIdbEsuLK3EOMEhzMSiK8XGeAQrwpiZVVqUX5
	8UWlOanFhxiTgR6dyCwlmpwPTCd5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2a
	WpBaBLOFiYNTqoHR3vHIXBPvwptPohITqjdeOqG86mvOQxNrzUaDvx8P7E887LH36EO9uMSp
	Ky/bBKY85lrM0zf1X6negbTtM6++U9XxkhRQkOvfvz18yqIQliiVGcFip06s6XCaZLV0n/7l
	kCmucpfv3lQN1Vm9+JLuolPb7fJud37bK5ZuYbvZNvD4v8Q9nA71SizFGYmGWsxFxYkAwVyU
	0x0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-spear.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index a18c319..db3ef61 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -400,8 +400,8 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
-	config->rtc = rtc_device_register(pdev->name, &pdev->dev,
-			&spear_rtc_ops, THIS_MODULE);
+	config->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&spear_rtc_ops, THIS_MODULE);
 	if (IS_ERR(config->rtc)) {
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 				PTR_ERR(config->rtc));
@@ -427,7 +427,6 @@ static int spear_rtc_remove(struct platform_device *pdev)
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
 	clk_disable_unprepare(config->clk);
 	device_init_wakeup(&pdev->dev, 0);
-- 
1.7.2.5


