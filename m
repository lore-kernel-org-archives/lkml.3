Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808Ab3DIFvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:51:06 -0400
Received: from mail.ispras.ru ([83.149.199.45]:49284 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab3DIFvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:51:04 -0400
Message-ID: <5163AC2B.7060804@ispras.ru>
Date: Tue, 09 Apr 2013 09:50:35 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] tty: mxser: forever loops on error
References: <20130409051838.GB1516@longonot.mountain>
In-Reply-To: <20130409051838.GB1516@longonot.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Thank you for the patch.

We are also trying to fix the issue:
https://lkml.org/lkml/2013/2/19/29
https://lkml.org/lkml/2013/4/8/55

and the fix is finally in Greg's tty git tree since yesterday:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
(tty-linus branch).

Best regards,
Alexey


On 04/09/2013 09:18 AM, Dan Carpenter wrote:
> There were a couple signedness bugs decrementing "i" which would lead to
> a forever loops.
>
> I've made a couple other variables signed as well because they are all
> related array offsets and it would be weird if they weren't the same
> type.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index d996038..a095859 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -2556,9 +2556,9 @@ static int mxser_probe(struct pci_dev *pdev,
>  {
>  #ifdef CONFIG_PCI
>  	struct mxser_board *brd;
> -	unsigned int i, j;
>  	unsigned long ioaddress;
>  	struct device *tty_dev;
> +	int i, j;
>  	int retval = -EINVAL;
>  
>  	for (i = 0; i < MXSER_BOARDS; i++)
> @@ -2700,7 +2700,7 @@ static int __init mxser_module_init(void)
>  {
>  	struct mxser_board *brd;
>  	struct device *tty_dev;
> -	unsigned int b, i, m;
> +	int b, i, m;
>  	int retval;
>  
>  	mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
>

