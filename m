Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3CLM70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 08:59:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3CLM7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 08:59:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Danny Huang <dahuang@nvidia.com>
Subject: Re: [PATCH v2] ARM: tegra: expose chip ID and revision
Date: Tue, 12 Mar 2013 12:59:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux@arm.linux.org.uk, swarren@wwwdotorg.org, hdoyu@nvidia.com,
        olof@lixom.net, gregkh@linuxfoundation.org, josephl@nvidia.com,
        pdeschrijver@nvidia.com, pgaikwad@nvidia.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
In-Reply-To: <1363089667-15737-1-git-send-email-dahuang@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303121259.18710.arnd@arndb.de>
X-Provags-ID: V02:K0:6V/yVOga4qeQQhk1GTyDG6g0owtD7NyTmJKGC8UNCTD
 BtZXaTnzPko7AcUBP7Fb6Q2zzLNfS3YlDLwOi4SqJGH49XqTCt
 Ya34xyP521oQPkYRGv4BtXucV0jBISUjeU0472LKBq7uPyp9i4
 5x/lGW0d9h0jWzEihLaOt4VwiKokY2JvhX+gepMR9UU0vGKILv
 eSps0HmIxBd4g/lzR0J3aByegG3nCe8+JGkV0B4C4uY1mLrlqn
 4S8gCbVJXAijNBBHjC5mPBOZpKTxa1+zGifB062PaXe6V/inTl
 58XSFk7VYy7Ql05rFlZ7lPeXnZVtHmluC18zn2l3s+DIJe78AN
 F/mMsBH09Bau270AgsdU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 March 2013, Danny Huang wrote:
> 
> +void __init tegra_soc_device_init(void)
> +{
> +       struct soc_device *soc_dev;
> +       struct soc_device_attribute *soc_dev_attr;
> +
> +       soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
> +       if (!soc_dev_attr)
> +               return;
> +
> +       soc_dev_attr->soc_id = kasprintf(GFP_KERNEL, "%d", tegra_chip_id);
> +       soc_dev_attr->revision = kasprintf(GFP_KERNEL, "%d", tegra_revision);
> +       soc_dev_attr->family = kasprintf(GFP_KERNEL, "Tegra");
> +
> +       soc_dev = soc_device_register(soc_dev_attr);
> +       if (IS_ERR_OR_NULL(soc_dev))
> +               kfree(soc_dev_attr);
> +
> +       return;

You are dropping the soc_dev on the floor here by just returning.

The idea of the soc node is to have all on-soc components be children
of that node, so you should instead pass it into of_platform_populate
as the parent device.

	Arnd
