Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaJNRKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 13:10:38 -0400
Received: from p3plex2out02.prod.phx3.secureserver.net ([184.168.131.14]:39376
	"EHLO p3plex2out02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755468AbaJNRKg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 13:10:36 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ian Abbott <abbotti@mev.co.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chase Southwood <chase.southwood@yahoo.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging: comedi: drivers: comedi_bond.c:  Changed from
 using strncat to strlcat
Thread-Topic: [PATCH] staging: comedi: drivers: comedi_bond.c:  Changed from
 using strncat to strlcat
Thread-Index: AQHP5hcI+EKa/w0lKkC5AbwZ55brT5wv1vsw
Date: Tue, 14 Oct 2014 17:10:35 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8825FE6234@P3PWEX4MB008.ex4.secureserver.net>
References: <1413116604-18554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1413116604-18554-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 12, 2014 5:23 AM, Rickard Strandqvist wrote:
>
> Changed from using strncat to strlcat to simplify the code
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/comedi/drivers/comedi_bond.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
> index 8450c99..5d19861 100644
> --- a/drivers/staging/comedi/drivers/comedi_bond.c
> +++ b/drivers/staging/comedi/drivers/comedi_bond.c
> @@ -262,12 +262,10 @@ static int do_dev_config(struct comedi_device *dev, struct comedi_devconfig *it)
>  			{
>  				/* Append dev:subdev to devpriv->name */
>  				char buf[20];
> -				int left =
> -				    MAX_BOARD_NAME - strlen(devpriv->name) - 1;
>  				snprintf(buf, sizeof(buf), "%u:%u ",
>  					 bdev->minor, bdev->subdev);
> -				buf[sizeof(buf) - 1] = 0;
>-				strncat(devpriv->name, buf, left);
> +				strlcat(devpriv->name, buf,
> +					sizeof(devpriv->name));
>  			}
>  
>  		}

Reviewed-by: H Hartley Sweeten <hsweeten@visionengravers.com>

