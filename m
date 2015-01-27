Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758583AbbA0X2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:28:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:60845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbbA0X2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:28:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,477,1418112000"; 
   d="scan'208";a="668663565"
Date: Wed, 28 Jan 2015 00:28:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@ml01.01.org, Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Berg Johannes <johannes.berg@intel.com>,
        Clement Perrochaud <clement.perrochaud@nxp.com>
Subject: Re: [PATCH v2 2/2] NFC: Add ACPI support for NXP PN544
Message-ID: <20150127232836.GB32667@ribalta.mp.intel.com>
References: <1422270817-10950-1-git-send-email-robert.dolca@intel.com>
 <1422270817-10950-3-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422270817-10950-3-git-send-email-robert.dolca@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,

On Mon, Jan 26, 2015 at 01:13:37PM +0200, Robert Dolca wrote:
> @@ -1022,9 +1127,12 @@ static int pn544_hci_i2c_probe(struct i2c_client *client,
>  			    PN544_I2C_FRAME_HEADROOM, PN544_I2C_FRAME_TAILROOM,
>  			    PN544_HCI_I2C_LLC_MAX_PAYLOAD,
>  			    pn544_hci_i2c_fw_download, &phy->hdev);
> -	if (r < 0)
> +	if (r < 0) {
> +		nfc_err(&client->dev, "HCI Probing error\n");
>  		goto err_hci;
> +	}
>  
> +	nfc_info(&client->dev, "NFC I2C driver loaded\n");
>  	return 0;
This is unrelated to this patch, so I removed that part.

Cheers,
Samuel.
