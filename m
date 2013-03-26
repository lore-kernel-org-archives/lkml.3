Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898Ab3CZKAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:00:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65198 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3CZKAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:00:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address from Device Tree
Date: Tue, 26 Mar 2013 10:00:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org> <CACRpkdZxU197moM_00UQr-tHdip4b50c+CfYkR5OK+MbwsE-aw@mail.gmail.com> <20130326094848.GA14151@gmail.com>
In-Reply-To: <20130326094848.GA14151@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303261000.33615.arnd@arndb.de>
X-Provags-ID: V02:K0:2XvhT5tJ6/wn/tH7Th4brUb5skaXGLVrAEKm33HuaHW
 DCOia6lvAreov0rmxWd+95V/JubOpQ1Lc59jOUaFitm8UFHA8f
 EfEDSqvPqb2J/pFrPOcxggyGu6/3O/BuaQeVsUoY1INgBPMXqM
 Rwx1lzQ8MK1NotgRHnD1N5jsDUwzI0sfgUki20UOovF5ryqxiD
 J45ozrah40TliThK5iFeMadct0fNz0Icz7MxUIkZmphHa7aCKJ
 s6MoqUhX3KN+A0J+76YN2IAicZIrsKH+JPgL0T4WYOtdwXFeFU
 A6pjc52YZnZ3cuFFFuuoEmWKWLIeo2WhdofuJ7NIyQgw564Zwr
 IaAwkuN29O5f9HdxRy+U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 March 2013, Lee Jones wrote:
> Bit for information for you. 
> 
> I have confirmed that the address locations are the same for
> all SoCs are the same. However, the size of the TCDM changes from 4k
> on the db8500 to 12k on the db8540.
> 
> Is there a way we can increase the size for the db8540 without
> creating an entire new DTS file? Seems overkill.

You can always override a property by setting it again, like

	soc {
		prcmu: db8500-prcmu@abcd0000 {
			reg = <0xabcd0000 0x1000>;
		};
	};

...


	&prcmu {
		reg = <0xabcd0000 0x3000>;
	}



	Arnd
