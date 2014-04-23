Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998AbaDWJu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:50:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10790 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDWJuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:50:22 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-57-53578cddcf5f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Wolfram Sang'" <wsa@the-dreams.de>
Cc: "'Olof Johansson'" <olof@lixom.net>, "'Ben Dooks'" <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1397254781-23833-1-git-send-email-dianders@chromium.org>
In-reply-to: <1397254781-23833-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] i2c: s3c2410: resume race fix
Date: Wed, 23 Apr 2014 18:50:20 +0900
Message-id: <038101cf5ed9$70b5a3a0$5220eae0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJFA9vjkmBzO6b39URJRKc7aH23gZozqwFA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zY927PeHBBpsfsVpMWneAyeLssoNs
	FpseX2O16Pj7hdHi8q45bBYzzu9jsjh1/TObxcoTs5gdODxmN1xk8fi76gWzx+Yl9R5XTjSx
	epw89YTF4/MmuQC2KC6blNSczLLUIn27BK6M9/c2MBc0cFU8X76QvYFxCkcXIyeHhICJxJ8J
	b5kgbDGJC/fWs3UxcnEICSxjlJj7aDILTNHXGYuYIBKLGCXOLprOCuH8ZZQ48f4MWDubgIbE
	4ffP2EFsEQF/iUtLloONYhY4B1T0ew0jSEJIwFXiz8THYA2cAm4SM3bMBWsQFjCSmHjnLlgN
	i4CqxNaph8HivAKWErsunGKDsAUlfky+B3YSs4CWxPqdx5kgbHmJzWveMkOcqiCx4+xrRogj
	jCTevTwFVSMise/FO0aImp/sEovOhkLsEpD4NvkQ0EwOoLisxKYDUGMkJQ6uuMEygVFiFpLN
	s5BsnoVk8ywkGxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECInpiTsY7x+wPsSYDLR+
	IrOUaHI+MCXklcQbGpsZWZiamBobmVuakSasJM6b/igpSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAOjSmt4eMm6bvFf1bssDgc84AxelRG7PZJzUnn41Mzyyn9ni8P+TD8b+m56hDBzz7pg
	9iuy4oym+7Kbev7q2TsvNEhTX6FXZaP/oiLeJU/7qSdTn1BRraD/iaK/ORES0wrDBJoKiwoX
	OyRM+D53o9E7sRzfnOikjQE1cfEmM9btPDznQurWfUosxRmJhlrMRcWJAKelsHf/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFKsWRmVeSWpSXmKPExsVy+t9jAd27PeHBBtd3MlpMWneAyeLssoNs
	FpseX2O16Pj7hdHi8q45bBYzzu9jsjh1/TObxcoTs5gdODxmN1xk8fi76gWzx+Yl9R5XTjSx
	epw89YTF4/MmuQC2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRb
	JRefAF23zBygg5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGe/vbWAu
	aOCqeL58IXsD4xSOLkZODgkBE4mvMxYxQdhiEhfurWfrYuTiEBJYxChxdtF0VgjnL6PEifdn
	wKrYBDQkDr9/xg5iiwj4S1xashysg1ngHFDR7zWMIAkhAVeJPxMfgzVwCrhJzNgxF6xBWMBI
	YuKdu2A1LAKqElunHgaL8wpYSuy6cIoNwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQpypI
	7Dj7mhHiCCOJdy9PQdWISOx78Y5xAqPQLCSjZiEZNQvJqFlIWhYwsqxiFE0tSC4oTkrPNdQr
	TswtLs1L10vOz93ECE4Zz6R2MK5ssDjEKMDBqMTDW7AyLFiINbGsuDL3EKMEB7OSCO+GzvBg
	Id6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HprO8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtFoH
	CgmkJ5akZqemFqQWwWxh4uCUamAsWs3i1PvhyD35XC0h18rMe+lRG+sv7g0IOy/pudeT69IC
	t3vB00LOJfJnFq9slPz5+t5fk2+XTuZVS9hkXT3SG3IpvvbtLqUHGSt9VaZK1cUp80+/GnZO
	qizi60XZVbvZhCyqHyr9K+/8G2Rvq76v7vaOS3bb/Of+v7bx9fb7+y+Zf/m1LW6vEktxRqKh
	FnNRcSIAqaecjl0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> From: Olof Johansson <olof@lixom.net>
> 
> Don't unmark the device as suspended until after it's been re-setup.
> 
> The main race would be w.r.t. an i2c driver that gets resumed at the same
> time (asyncronously), that is allowed to do a transfer since suspended
> is set to 0 before reinit, but really should have seen the -EIO return
> instead.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
Kukjin

> ---
>  drivers/i2c/busses/i2c-s3c2410.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-
> s3c2410.c
> index ae44910..bb3a996 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -1276,10 +1276,10 @@ static int s3c24xx_i2c_resume(struct device *dev)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct s3c24xx_i2c *i2c = platform_get_drvdata(pdev);
> 
> -	i2c->suspended = 0;
>  	clk_prepare_enable(i2c->clk);
>  	s3c24xx_i2c_init(i2c);
>  	clk_disable_unprepare(i2c->clk);
> +	i2c->suspended = 0;
> 
>  	return 0;
>  }
> --
> 1.9.1.423.g4596e3a

