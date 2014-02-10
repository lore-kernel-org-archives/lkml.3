Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaBJGlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 01:41:03 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:53304 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbaBJGlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 01:41:01 -0500
Message-ID: <1392014458.21271.6.camel@linux-fkkt.site>
Subject: Re: [PATCH 1/2 v2] usbnet: fix bad header length bug
From: Oliver Neukum <oliver@neukum.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Ming Lei <ming.lei@canonical.com>,
        Mark Brown <broonie@linaro.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Glen Turner <gdt@gdt.id.au>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 10 Feb 2014 07:40:58 +0100
In-Reply-To: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
References: <1391987174-21828-1-git-send-email-emilgoode@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 00:06 +0100, Emil Goode wrote:
> The AX88772B occasionally send rx packets that cross urb boundaries
> and the remaining partial packet is sent with no hardware header.
> When the buffer with a partial packet is of less number of octets
> than the value of hard_header_len the buffer is discarded by the
> usbnet module. This is causing dropped packages and error messages
> in dmesg.
> 
> This can be reproduced by using ping with a packet size
> between 1965-1976.

Well, then how about simply removing the check?
It seems to have outlived its usefulness.

	Regards
		Oliver


