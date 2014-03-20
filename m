Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaCTC7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:59:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9851 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaCTC7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:59:20 -0400
X-AuditID: cbfee68e-b7f566d000002344-dd-532a5986bb85
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, t.figa@samsaung.com, b.zolnierkie@samsaung.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv4 0/5] devfreq: exynos: Fix minor issue and code clean to
 remove legacy method
Date: Thu, 20 Mar 2014 11:59:08 +0900
Message-id: <1395284353-22458-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkWLctUivY4EiXpUVHz28Wi+tfnrNa
	nG16w25xedccNosZ5/cxWdxuXMFm8XjFW3aLm1NnMzlweCze85LJ4+fy7ewefVtWMXp83iQX
	wBLFZZOSmpNZllqkb5fAlfFm1UzGgjW8FZ83cjUwfuHqYuTkkBAwkZh46xUrhC0mceHeerYu
	Ri4OIYGljBL3b65igik6um4BM0RiEaPEjjUHoZxGJom++wtZQKrYBLQk9r+4wQZiiwiYS+xa
	+hNsFLPATkaJ/bcXMXYxcnAICyRIPL0hB1LDIqAqsf3+KnYQm1fAVWJ/+1tGiG1yEh/2PGIH
	6ZUQaGaXWNHSzwrRICDxbfIhFpA5EgKyEpsOMEPUS0ocXHGDZQKj4AJGhlWMoqkFyQXFSelF
	RnrFibnFpXnpesn5uZsYgWF7+t+zvh2MNw9YH2JMBho3kVlKNDkfGPZ5JfGGxmZGFqYmpsZG
	5pZmpAkrifMuepgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGRs3Keecauo9ay8y69eXOB
	R/Gz5PmlekyfZjDtz75x80LIQZ0FVf9n9tlVTVgctW9thuU6e7nNtletLkRMm5O+kXdVSnTF
	E4eLXrmrL9dWWCnrTt+mXfLNbV+LQzqn316Byz9TY5rXXn6bZ7n5TmSGiVhGK99qh7DW2dLt
	vSudtzqEyUQ6fbVVYinOSDTUYi4qTgQAwwUj8nECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd22SK1gg0vdhhYdPb9ZLK5/ec5q
	cbbpDbvF5V1z2CxmnN/HZHG7cQWbxeMVb9ktbk6dzeTA4bF4z0smj5/Lt7N79G1ZxejxeZNc
	AEtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAd
	SgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMN6tmMhas4a34vJGrgfEL
	VxcjJ4eEgInE0XULmCFsMYkL99azdTFycQgJLGKU2LHmIDOE08gk0Xd/IQtIFZuAlsT+FzfY
	QGwRAXOJXUt/gnUwC+xklNh/exFjFyMHh7BAgsTTG3IgNSwCqhLb769iB7F5BVwl9re/ZYTY
	JifxYc8j9gmM3AsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEfFM6kdjCsbLA4xCnAw
	KvHwrtijGSzEmlhWXJl7iFGCg1lJhNfaXStYiDclsbIqtSg/vqg0J7X4EGMy0PaJzFKiyfnA
	iM0riTc0NjEzsjQyN7QwMjYnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsawNo29G//W
	y05J1lDm3N6bL8cb0HrB3/PoH4moCWfSV8sqCH5Pme5wgeP2DBfjDd/SNOoeXs39n3Q+OOno
	dhexmkNf9gvLXM/012MMSWQ0O1eZo9IdeON8kMjm1knpDQaae/Tm1OcsM5Wfm+Li4bou6lVj
	0T5hs5VPQp75lS1SsQgP07/KrsRSnJFoqMVcVJwIAMcg623OAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset use SIMPLE_DEV_PM_OPS macro intead of legacy method and fix
probe fail if CONFIG_PM_OPP is disabled. Also, this patchset fix minor issue.

Changes from v3:
- Discard patches related to DT support because DT support patch of patchset
  don't satisfy the basic of dt concept. So, I'm going to implement DT support
  patch regardless this patchset separately.
- Use SIMPLE_DEV_PM_OPS macro instead of SET_SYSTEM_SLEEP_PM_OPS macro
- Delete devfreq->profile->exit callback to improve readability when failure
  happen in probe().
- Add exynos5 patch to clean code

Changes from v2:
- Add detailed description to Documentation/devicetree/bindings/exynos4_bus.txt
  and change patch description of patch#8
- Change the sequence of patchset in patch #1 ~ #4
- Fix minor issue

Changes from v1:
- Add exynos4_bus.txt documentation for devicetree guide
- Fix probe failure if CONFIG_PM_OPP is disabled
- Fix typo and resource leak(regulator/clock/memory) when happening probe failure
- Add additionally comment for PPMU usage instead of previous PPC
- Split separate patch to remove ambiguous of patch

Chanwoo Choi (5):
  devfreq: exynos4: Fix bug of resource leak and code clean on probe()
  devfreq: exynos4: Use SIMPLE_DEV_PM_OPS macro
  devfreq: exynos4: Add CONFIG_PM_OPP dependency to fix probe fail
  devfreq: exynos5: Use SIMPLE_DEV_PM_OPS macro
  devfreq: exynos5: Add CONFIG_PM_OPP dependency to fix probe fail

 drivers/devfreq/Kconfig              |  2 ++
 drivers/devfreq/exynos/exynos4_bus.c | 43 ++++++++++++++++++++++--------------
 drivers/devfreq/exynos/exynos5_bus.c |  7 ++++--
 3 files changed, 34 insertions(+), 18 deletions(-)

-- 
1.8.0

