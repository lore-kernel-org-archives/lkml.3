Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758860AbaDBNzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:55:09 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39756 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758600AbaDBNzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:55:06 -0400
MIME-Version: 1.0
In-Reply-To: <CACAvsv6eCoWEU7ZNd5158-V3n=ZVo5O04CZa2EWE78e_tZEXPA@mail.gmail.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-10-git-send-email-acourbot@nvidia.com> <CACAvsv6eCoWEU7ZNd5158-V3n=ZVo5O04CZa2EWE78e_tZEXPA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 2 Apr 2014 22:54:45 +0900
Message-ID: <CAAVeFuLbwqGRbE1LFJh54_4FE601w=czHOfBB=ETZ0RtFqdicQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/12] drm/nouveau/graph: pad firmware code at
 load time
To: Ben Skeggs <skeggsb@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 1:22 PM, Ben Skeggs <skeggsb@gmail.com> wrote:
> On Mon, Mar 24, 2014 at 6:42 PM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Pad the microcode to a multiple of 0x40, otherwise firmware will fail to
>> run from non-prepadded firmware files.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> index f997a18f5760..367e72daf8b1 100644
>> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> @@ -768,6 +768,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
>>                         nv_wr32(priv, fuc_base + 0x0188, i >> 6);
>>                 nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
>>         }
>> +
>> +       /* code must be padded to 0x40 */
>> +       for (; i < (((code->size / 4) + 0x3f) & ~0x3f); i++)
> "for (; i & 0x3f; i++)" would work just as well :)

Indeed. >_<
