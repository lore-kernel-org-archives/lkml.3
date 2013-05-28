Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab3E1E6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 00:58:17 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:44218 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384Ab3E1E6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 00:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <51A42ED5.2060104@wwwdotorg.org>
References: <1369626821-28494-1-git-send-email-acourbot@nvidia.com> <51A42ED5.2060104@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 28 May 2013 13:57:51 +0900
Message-ID: <CAAVeFuLYe6xuzV4Y_r8GXoPWd8n3fn=jyp06hRTJVE-t1pf9eg@mail.gmail.com>
Subject: Re: [PATCH v2] video: simplefb: add mode parsing function
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Rob Clark <robclark@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rpi-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 1:13 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/26/2013 09:53 PM, Alexandre Courbot wrote:
>> The naming scheme of simplefb's mode is precise enough to allow building
>> the mode structure from it instead of using a static list of modes. This
>> patch introduces a function that does this. In case exotic modes that
>> cannot be represented from their name alone are needed, the static list
>> of modes is still available as a backup.
>>
>> It also changes the order in which colors are declared from MSB first to
>> the more standard LSB first.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> Changes from v1:
>> - amended documentation following Stephen's suggestion
>> - allow parsing of bitfields larger than 9 bits
>> - made it clear that the parsing order of bits is changed with respect
>>   to the original patch
>>
>> Andrew, since this patch introduces a (small) change in the DT bindings,
>> could we try to merge it during the -rc cycle so we don't have to come
>> with a more complex solution in the future?
>
> So, I think we shouldn't change the DT binding at all now. The original
> driver is now merged for 3.10, and I think it's far too late to take
> code that implements new features for 3.10. This means that we couldn't
> merge this patch until 3.11. However, by then, we shouldn't be changing
> the DT binding in incompatible ways. Olof has already published some
> U-Boot binaries that use the current binding, and on IRC indicated he'd
> prefer not to change the binding because of that.
>
> As such, we should either:
>
> a) Just add new entries into the format array that already exists in the
> driver. Given David's response, this might be simplest.
>
> b) Extend the DT binding in a 100% backwards-compatible way, which would
> mean defaulting the bit-order to match the existing 1 format, and adding
> a new Boolean property to indicate that the format string is specified
> in the other order.

a) is definitely simpler, so let's do that and drop this patch. Sorry
about the noise.

Alex.
