Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab3FFSDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 14:03:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50743 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750971Ab3FFSDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 14:03:44 -0400
Message-ID: <1370541822.2209.16.camel@joe-AO722>
Subject: Re: [PATCH 6/6] keucr: fix some alignment- and whitespace-problems
From: Joe Perches <joe@perches.com>
To: Johannes Schilling <of82ecuq@cip.cs.fau.de>
Cc: linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de,
        Al Cho <acho@novell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Kurt Kanzenbach <shifty91@gmail.com>, devel@driverdev.osuosl.org,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 06 Jun 2013 11:03:42 -0700
In-Reply-To: <1370535050-7167-7-git-send-email-of82ecuq@cip.cs.fau.de>
References: <20130605094517.GS28112@mwanda>
	 <1370535050-7167-1-git-send-email-of82ecuq@cip.cs.fau.de>
	 <1370535050-7167-7-git-send-email-of82ecuq@cip.cs.fau.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-06 at 18:10 +0200, Johannes Schilling wrote:
> resolves checkpatch errors and warnings regarding whitespace around
> operators, line lengths and indentation.

I suggest adding --strict to your checkpatch runs to
report a few more style usage elements.

> diff --git a/drivers/staging/keucr/init.c b/drivers/staging/keucr/init.c
[]
> @@ -98,11 +98,16 @@ int ENE_SMInit(struct us_data *us)
[]
>  	if (us->SM_Status.Insert && us->SM_Status.Ready) {
> -		dev_info(&us->pusb_dev->dev, "Insert     = %x\n", us->SM_Status.Insert);
[]
> +		dev_info(&us->pusb_dev->dev, "Insert     = %x\n",
> +					     us->SM_Status.Insert);

I think this would be nicer aligning the arguments
to the open parenthesis like:

		dev_info(&us->pusb_dev->dev, "Insert     = %x\n",
			 us->SM_Status.Insert);

but using

		us_info(us, "Insert     = %x\n", us->SM_Status.Insert);

would be nicer still and fit 80 cols, etc...

Another option would be to use a macro like:

#define us_show_status(us, field)				\
	us_info(us, "%-11s= %x\n", #field, us->SM_Status.field)

And these become

	us_show_status(us, "Insert");
	us_show_status(us, "Ready");
	us_show_status(us, "WtP");

etc...

It depends on how many of these actually exist whether
or not a macro is appropriate.


