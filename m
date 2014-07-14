Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaGNKUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:20:05 -0400
Received: from smtp207.alice.it ([82.57.200.103]:3242 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbaGNKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:19:54 -0400
Date: Mon, 14 Jul 2014 12:19:38 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/4] Style fixes
Message-Id: <20140714121938.c9fc3f2526d029b13c7ceb8e@ao2.it>
In-Reply-To: <1405236262-8070-4-git-send-email-jm@lentin.co.uk>
References: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
	<1405236262-8070-4-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2014 08:24:21 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>

Reviewed-by: Antonio Ospite <ao2@ao2.it>

> ---
>  drivers/hid/hid-lenovo.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
> index d11e337..a1a693c 100644
> --- a/drivers/hid/hid-lenovo.c
> +++ b/drivers/hid/hid-lenovo.c
> @@ -349,7 +349,7 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
>  	struct lenovo_drvdata_tpkbd *data_pointer;
>  	size_t name_sz = strlen(dev_name(dev)) + 16;
>  	char *name_mute, *name_micmute;
> -	int i;
> +	int i, ret;

Preferred style is one declaration per line, but this style is also
quite common in kernel, so it's not a big deal.

>
>  	/*
>  	 * If this is the pointer half of the keyboard, input_mapping should
> @@ -369,10 +369,9 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
>  	if (!hid_validate_values(hdev, HID_OUTPUT_REPORT, 3, 0, 2))
>  		return -ENODEV;
>  
> -	if (sysfs_create_group(&hdev->dev.kobj,
> -				&lenovo_attr_group_tpkbd)) {
> +	ret = sysfs_create_group(&hdev->dev.kobj, &lenovo_attr_group_tpkbd);
> +	if (ret)
>  		hid_warn(hdev, "Could not create sysfs group\n");
> -	}
>  
>  	data_pointer = devm_kzalloc(&hdev->dev,
>  				    sizeof(struct lenovo_drvdata_tpkbd),
> -- 
> 2.0.0
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
