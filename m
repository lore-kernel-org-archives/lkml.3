Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbaDILMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:12:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9953 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:12:15 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7fc96d000004885-ab-53452b0d72cb
Content-transfer-encoding: 8BIT
Message-id: <1397041934.11424.2.camel@AMDC1943>
Subject: Re: [PATCH] ASoC: core: Fix Sparse incompatible types warning
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Date: Wed, 09 Apr 2014 13:12:14 +0200
In-reply-to: <5345279F.6070005@metafoo.de>
References: <1397028108-10976-1-git-send-email-k.kozlowski@samsung.com>
 <5345279F.6070005@metafoo.de>
X-Mailer: Evolution 3.8.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xK7p82q7BBrfiLK5cPMRkMfXhEzaL
	JZPns1p8u9LBZHF51xw2i85d/awWLze/YXJg99jwuYnNY+esu+wem1Z1snkseXOI1WPf22Vs
	HptPV3t83iQXwB7FZZOSmpNZllqkb5fAlTFvwUyWgv0cFc8mdrI0MP5g62Lk5JAQMJE4/PUx
	C4QtJnHh3nqgOBeHkMBSRol1S7ezgiR4BQQlfky+B1TEwcEsIC9x5FI2SJhZQF1i0rxFzBD1
	nxklfra2QtXrS+yY+gtsqLCAm8T05tnMIDabgLHE5uVLwBaLCGhI/H8ziR2kmVngOKPE3XVX
	wRIsAqoSf+f+BxvEKaAlMbVvAVizkEC6xJvLB5khLlWSOLduDeMERoFZSO6bhXDfLCT3LWBk
	XsUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREvRfdzAuPWZ1iFGAg1GJh1fB0iVYiDWxrLgy
	9xCjBAezkgjvczbXYCHelMTKqtSi/Pii0pzU4kOMTBycUg2M09jNXZYfT+gWqA2tbRCfWyC9
	+dTNa8Xy+W7//kzrfrXwy+FXtecOefSqTNULj27btrp/QfDfP/uiX7MoLL/vuefwq+qb9pP8
	1GS8TlxmbXt9++s8oTJ/o9dcy9a/XuNYKTq/xMTyUfT8yDdlLy94/RM8GD3PY875Z4xCO0wC
	xD7Mixf8y9y+WomlOCPRUIu5qDgRALQpvvVYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-04-09 at 12:57 +0200, Lars-Peter Clausen wrote:
> On 04/09/2014 09:21 AM, Krzysztof Kozlowski wrote:
> > Fix following Sparse warning:
> > sound/soc/soc-core.c:252:20: error: incompatible types in comparison expression (different type sizes)
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >   sound/soc/soc-core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> > index 051c006281f5..41f6178249df 100644
> > --- a/sound/soc/soc-core.c
> > +++ b/sound/soc/soc-core.c
> > @@ -249,7 +249,7 @@ static ssize_t codec_reg_write_file(struct file *file,
> >   	struct snd_soc_codec *codec = file->private_data;
> >   	int ret;
> >
> > -	buf_size = min(count, (sizeof(buf)-1));
> > +	buf_size = min(count, (size_t)(sizeof(buf)-1));
> 
> But shouldn't the type of sizeof already be size_t?

Hmmm... yes it should. It looks like a false positive from Sparse so the
commit message should be rather "Suppress" than "Fix".

Best regards,
Krzysztof

