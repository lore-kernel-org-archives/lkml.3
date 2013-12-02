Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3LBOcH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:32:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab3LBOcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:32:04 -0500
Date: Mon, 2 Dec 2013 15:31:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: HID: kye: Add report fixup for Genius Manticore Keyboard
In-Reply-To: <20131202142829.GA2411@redhat.com>
Message-ID: <alpine.LNX.2.00.1312021531340.24931@pobox.suse.cz>
References: <20131128051223.28802660D26@gitolite.kernel.org> <20131130214211.GA16854@redhat.com> <alpine.LNX.2.00.1312021515300.24931@pobox.suse.cz> <20131202142829.GA2411@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Dec 2013, Dave Jones wrote:

> Commit 4a2c94c9b6 inadvertantly removed a break from the GENIUS_GX_IMPERATOR case.
> Spotted by Coverity.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
> index ecb5ca669e97..e77696367591 100644
> --- a/drivers/hid/hid-kye.c
> +++ b/drivers/hid/hid-kye.c
> @@ -341,6 +341,7 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
>  		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
>  					"Genius Gx Imperator Keyboard");
> +		break;
>  	case USB_DEVICE_ID_GENIUS_MANTICORE:
>  		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,

I've already taken Ben's original patch:

	https://git.kernel.org/cgit/linux/kernel/git/jikos/hid.git/commit/?h=for-3.13/upstream-fixes

-- 
Jiri Kosina
SUSE Labs
