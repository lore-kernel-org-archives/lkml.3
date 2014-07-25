Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbaGYNdp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 09:33:45 -0400
Received: from smtp205.alice.it ([82.57.200.101]:45316 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752232AbaGYNdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 09:33:44 -0400
Date: Fri, 25 Jul 2014 15:33:24 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] HID: lenovo: Style fixes
Message-Id: <20140725153324.3463287fa928e6d495801b46@ao2.it>
In-Reply-To: <1406154648-14000-4-git-send-email-jm@lentin.co.uk>
References: <1406154648-14000-1-git-send-email-jm@lentin.co.uk>
	<1406154648-14000-4-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 23:30:47 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>

Jamie, please send a v6 of this patch alone[*], where you print the
return value as Dmitry suggested . You do print it in a similar
statement of the subsequent patch, so this makes even more sense.

FWIW I'd already take the patch as it is and consider it a readability
improvement, but I now realize that the suggestion of not calling
functions in conditions is not mentioned anywhere in
Documentation/CodingStyle, so maybe I would just be over-zealous.

Ciao,
   Antonio

[*] You can use the --in-relpy-to option of git-send-email to make it a
reply to your v5 3/4

> ---
>  drivers/hid/hid-lenovo.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
> index a56b9e7..6d55939 100644
> --- a/drivers/hid/hid-lenovo.c
> +++ b/drivers/hid/hid-lenovo.c
> @@ -350,6 +350,7 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
>  	size_t name_sz = strlen(dev_name(dev)) + 16;
>  	char *name_mute, *name_micmute;
>  	int i;
> +	int ret;
>  
>  	/*
>  	 * Only register extra settings against subdevice where input_mapping
> @@ -368,10 +369,9 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
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
