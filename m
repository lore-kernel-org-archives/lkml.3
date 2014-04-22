Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaDVCIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 22:08:50 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5157 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDVCIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 22:08:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 21 Apr 2014 19:03:16 -0700
Message-ID: <5355CF27.8000401@nvidia.com>
Date: Tue, 22 Apr 2014 11:08:39 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Skeggs <skeggsb@gmail.com>, Ilia Mirkin <imirkin@alum.mit.edu>
CC: Alexandre Courbot <gnurou@gmail.com>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 07/10] drm/nouveau/graph: pad firmware code at load
 time
References: <1398060142-7937-1-git-send-email-acourbot@nvidia.com>	<1398060142-7937-8-git-send-email-acourbot@nvidia.com>	<CAKb7UviQ6s8wRqwLVnE_A0NOw=WcVdFXG_wWmnZypwuaW_hnuw@mail.gmail.com> <CACAvsv7J7yUaug=CoUfsPg5PXf=ZmwUD9XvCt4CqAvnamQNN9A@mail.gmail.com>
In-Reply-To: <CACAvsv7J7yUaug=CoUfsPg5PXf=ZmwUD9XvCt4CqAvnamQNN9A@mail.gmail.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 08:48 AM, Ben Skeggs wrote:
> On Tue, Apr 22, 2014 at 4:03 AM, Ilia Mirkin <imirkin@alum.mit.edu> wrote:
>> On Mon, Apr 21, 2014 at 2:02 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>> Pad the microcode to a multiple of 0x40 bytes, otherwise firmware will
>>
>> bytes or u32's? From the code, I'm guessing the latter. (Similar
>> concern about comment in the code.)
>>
>>> fail to run from non-prepadded firmware files.
>>>
>>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>>> Reviewed-by: Thierry Reding <treding@nvidia.com>
>>> ---
>>>   drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c | 4 ++++
>>>   1 file changed, 4 insertions(+)
>>>
>>> diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>>> index e5b75f189988..013475c62986 100644
>>> --- a/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>>> +++ b/drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c
>>> @@ -894,6 +894,10 @@ nvc0_graph_init_fw(struct nvc0_graph_priv *priv, u32 fuc_base,
>>>                          nv_wr32(priv, fuc_base + 0x0188, i >> 6);
>>>                  nv_wr32(priv, fuc_base + 0x0184, code->data[i]);
>>>          }
>>> +
>>> +       /* code must be padded to 0x40 bytes */
>>> +       for (; i & 0x3f; i++)
>>> +               nv_wr32(priv, fuc_base + 0x0184, 0);
> It's 256 bytes indeed.

Fixed, thanks!
