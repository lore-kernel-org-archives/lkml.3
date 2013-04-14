Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3DNPPI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 11:15:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:39249 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab3DNPPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 11:15:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Yeung <yc_matrix@yahoo.com>
Subject: Re: [PATCH v3 2/2] pps: new client driver using GPIO
Date: Sun, 14 Apr 2013 15:12:40 +0000 (UTC)
Message-ID: <loom.20130414T165523-726@post.gmane.org>
References: <1310138846-1164-1-git-send-email-jamesnuss@nanometrics.ca> <1310138846-1164-3-git-send-email-jamesnuss@nanometrics.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 74.105.84.42 (Mozilla/5.0 (Windows NT 6.0; WOW64; rv:17.0) Gecko/20100101 Firefox/17.0)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

I am a newbie to linux kernel device driver and would like to use this
client driver on my uClinux running on the NIOS2. Can you kindly point me to
the right direction, since I am using a device tree and believe this doesn't
support device tree, right? What do I need to add/modify so I can use a
input GPIO as a source? I saw a google post to add this code to (?? an
unknown) and then you need to call pps_init in the configuration routine (??
not sure what it mean)

add
/* PPS-GPIO platform data */
static struct pps_gpio_platform_data pps_gpio_info = {
.assert_falling_edge = false,
.capture_clear= false,
.gpio_pin=63,
.gpio_label="PPS",
};

static struct platform_device pps_gpio_device = {
.name = "pps-gpio",
.id = -1,
.dev = {
.platform_data = &pps_gpio_info
},
};

static void pps_init(int evm_id, int profile)
{
int err;

err = platform_device_register(&pps_gpio_device);
if (err) {
pr_warning("Could not register PPS_GPIO device");
}
}

Thanks in advance for any help,

Yeung



