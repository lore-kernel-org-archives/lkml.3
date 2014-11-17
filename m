Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaKQPOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:14:32 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17554 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaKQPO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:14:28 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-99-546a10d20d98
Subject: [PATCH 2/2] kernel/kexec: free crypto_shash using crypto_free_shash
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@xmission.com>
Cc: Michal Marek <mmarek@suse.cz>, Herbert Xu <herbert@gondor.apana.org.au>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 17 Nov 2014 18:14:26 +0400
Message-id: <20141117151426.10739.86414.stgit@buzz>
In-reply-to: <20141117151420.10739.16342.stgit@buzz>
References: <20141117151420.10739.16342.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsVy+t/xy7qXBLJCDKa8NrCYc76FxeL/thZ2
	i9k/LzFZdL+SsVj24DSjxY+dvawWu09/ZbK4f+8nk8XlXXPYLFr2XWCyOPZyOZMDt8eWlTeZ
	PLYdUPU4dqyV2WPvliyPzUvqPfq2rGL0OLPgCLvH501yHlMOtbMEcEZx2aSk5mSWpRbp2yVw
	ZfR+vs5UMI+louPaItYGxv3MXYycHBICJhJzv89igbDFJC7cW8/WxcjFISSwlFFi76x7TBBO
	I5PEguMfwaqEBXwkrp5/yApiswmYSWzbd5sRxBYRSJVYsOgIM0gDs0A3k8SqVy+Aujk4WARU
	Jb5vzAQxeQWMJT7/swIp5wRa3D1rK9gYIaDwnq4tYLaogJzEysstYDavgKDEj8n3WEBamQXU
	JaZMyQUJMwvIS2xe85Z5AqPALCRVsxCqZiGpWsDIvIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/
	dxMjJFK+7mBceszqEKMAB6MSD++BoswQIdbEsuLK3EOMEhzMSiK8MReBQrwpiZVVqUX58UWl
	OanFhxiZODilGhizq0NrGFvUH35nd/gqx/1N/JC9y0tBJ516Pk3/c/Ud0tyLc2LZN/gfzX8T
	uXiOu07Jilgz23M3G49E/Qv/dlZRwGf9xzk3Vm1xCog8nST51jrW9Nnll9vebs/bfdDhe52i
	TrBRr9a/RqPlRn+2z49+ndFvEHn0eofCjmMa3SVsWkGSn60ePlBiKc5INNRiLipOBABG9c6g
	cgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These objects have special freeing functions which cares about
proper destruction and reference counting.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 kernel/kexec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 2abf9f6..5a62311 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -2286,7 +2286,7 @@ out_free_sha_regions:
 out_free_desc:
 	kfree(desc);
 out_free_tfm:
-	kfree(tfm);
+	crypto_free_shash(tfm);
 out:
 	return ret;
 }

