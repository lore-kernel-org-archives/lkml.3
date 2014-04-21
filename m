Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbaDUXsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 19:48:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36068 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaDUXsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 19:48:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAKb7UviQ6s8wRqwLVnE_A0NOw=WcVdFXG_wWmnZypwuaW_hnuw@mail.gmail.com>
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>
	<1398060142-7937-8-git-send-email-acourbot@nvidia.com>
	<CAKb7UviQ6s8wRqwLVnE_A0NOw=WcVdFXG_wWmnZypwuaW_hnuw@mail.gmail.com>
Date: Tue, 22 Apr 2014 09:48:03 +1000
Message-ID: <CACAvsv7J7yUaug=CoUfsPg5PXf=ZmwUD9XvCt4CqAvnamQNN9A@mail.gmail.com>
Subject: Re: [PATCH v2 07/10] drm/nouveau/graph: pad firmware code at load time
From: Ben Skeggs <skeggsb@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 4:03 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
> On Mon, Apr 21, 2014 at 2:02 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> Pad the microcode to a multiple of 0x40 bytes, otherwise firmware will
>
> bytes or u32's? From the code, I'm guessing the latter. (Similar
> concern about comment in the code.)
>
>> fail to run from non-prepadded firmware files.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> Reviewed-by: Thierry Reding <treding@nvidia.com>
>> ---
>>  drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> index e5b75f189988..013475c62986 100644
>> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>> @@ -894,6 +894,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
>>                         nv_wr32(priv, fuc_base + 0x0188, i >> 6);
>>                 nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
>>         }
>> +
>> +       /* code must be padded to 0x40 bytes */
>> +       for (; i & 0x3f; i++)
>> +               nv_wr32(priv, fuc_base + 0x0184, 0);
It's 256 bytes indeed.

>>  }
>>
>>  static void
>> --
>> 1.9.2
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
