Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab3HSRmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:42:32 -0400
Received: from titanium.nobletdesign.com ([64.34.172.148]:60579 "EHLO
	titanium.nobletdesign.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab3HSRmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:42:31 -0400
Message-ID: <52125904.1040200@gnat.ca>
Date: Mon, 19 Aug 2013 11:42:28 -0600
From: "Nathanael D. Noblet" <nathanael@gnat.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [ 28/45] ALSA: hda - Add a fixup for Gateway LT27
References: <20130818203620.996166594@linuxfoundation.org> <20130818203622.954537901@linuxfoundation.org>
In-Reply-To: <20130818203622.954537901@linuxfoundation.org>
Content-Type: multipart/mixed;
 boundary="------------040404070003060207060305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040404070003060207060305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

No objection, other than that I submitted a revision to that patch... 
Added an additional piece of hardware. The full patch should be include 
two lines.



On 08/18/2013 02:36 PM, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Takashi Iwai <tiwai@suse.de>
>
> commit 1801928e0f99d94c55e33c584c5eb2ff5e246ee6 upstream.
>
> Gateway LT27 needs a fixup for the inverted digital mic.
>
> Reported-by: "Nathanael D. Noblet" <nathanael@gnat.ca>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>   sound/pci/hda/patch_realtek.c |    1 +
>   1 file changed, 1 insertion(+)
>
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -4210,6 +4210,7 @@ static const struct snd_pci_quirk alc662
>   	SND_PCI_QUIRK(0x1025, 0x0308, "Acer Aspire 8942G", ALC662_FIXUP_ASPIRE),
>   	SND_PCI_QUIRK(0x1025, 0x031c, "Gateway NV79", ALC662_FIXUP_SKU_IGNORE),
>   	SND_PCI_QUIRK(0x1025, 0x0349, "eMachines eM250", ALC662_FIXUP_INV_DMIC),
> +	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
>   	SND_PCI_QUIRK(0x1025, 0x038b, "Acer Aspire 8943G", ALC662_FIXUP_ASPIRE),
>   	SND_PCI_QUIRK(0x1028, 0x05d8, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
>   	SND_PCI_QUIRK(0x1028, 0x05db, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
>
>
>


-- 
Nathanael d. Noblet
t 403.875.4613

--------------040404070003060207060305
Content-Type: text/x-patch;
 name="alsa-realtek-inverted-mic.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="alsa-realtek-inverted-mic.patch"

--- a/sound/pci/hda/patch_realtek.c	2013-08-15 13:17:49.804492932 -0600
+++ b/sound/pci/hda/patch_realtek.c	2013-08-15 15:17:46.390273328 -0600
@@ -4208,6 +4208,8 @@
 	SND_PCI_QUIRK(0x17aa, 0x3a0d, "Lenovo Ideapad Y550", ALC662_FIXUP_IDEAPAD),
 	SND_PCI_QUIRK(0x19da, 0xa130, "Zotac Z68", ALC662_FIXUP_ZOTAC_Z68),
 	SND_PCI_QUIRK(0x1b35, 0x2206, "CZC P10T", ALC662_FIXUP_CZC_P10T),
+	SND_PCI_QUIRK(0x1025, 0x034a, "Gateway LT27", ALC662_FIXUP_INV_DMIC),
+	SND_PCI_QUIRK(0x1025, 0x022f, "Acer Aspire One", ALC662_FIXUP_INV_DMIC),
 
 #if 0
 	/* Below is a quirk table taken from the old code.

--------------040404070003060207060305--
