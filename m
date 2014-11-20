Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaKTMZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:25:24 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:36600 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaKTMZW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:25:22 -0500
From: =?UTF-8?B?RUxBTiDlionlmInpp78=?= <scott.liu@emc.com.tw>
To: "'Oliver Neukum'" <oneukum@suse.de>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        "'Vincent Wang'" <vincent.wang@emc.com.tw>,
        "'Jeff Chuang'" <jeff.chuang@emc.com.tw>,
        "'Benson Leung'" <bleung@chromium.org>,
        "'Benjamin Tissoires'" <benjamin.tissoires@gmail.com>,
        "'Henrik Rydberg'" <rydberg@euromail.se>,
        "'David Herrmann'" <dh.herrmann@gmail.com>
References: <1388146515-19481-1-git-send-email-scott.liu@emc.com.tw>	 <20141120081113.GA37534@dtor-ws> <1416479490.28599.13.camel@linux-0dmf.site>
In-Reply-To: <1416479490.28599.13.camel@linux-0dmf.site>
Subject: RE: [PATCH v1] Input: elants_i2c: Add Elan touchscreen support
Date: Thu, 20 Nov 2014 20:25:15 +0800
Message-ID: <000001d004bd$0ad90830$208b1890$@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQGPAtNJZnsxghQAUQdBW7YNhjLKyQLlfmrAAacox4acxwy7AA==
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Oliver:

-----Original Message-----
From: Oliver Neukum [mailto:oneukum@suse.de] 
Sent: Thursday, November 20, 2014 6:32 PM
To: Dmitry Torokhov
Cc: scott; linux-kernel@vger.kernel.org; linux-input@vger.kernel.org; Vincent Wang; Jeff Chuang; Benson Leung; Benjamin Tissoires; Henrik Rydberg; David Herrmann
Subject: Re: [PATCH v1] Input: elants_i2c: Add Elan touchscreen support



> +static int elants_i2c_sw_reset(struct i2c_client *client) {
> +       const u8 soft_rst_cmd[] = { 0x77, 0x77, 0x77, 0x77 };
> +       int error;
> +
> +       error = elants_i2c_send(client, soft_rst_cmd,
> +                               sizeof(soft_rst_cmd));
> +       if (error) {
> +               dev_err(&client->dev, "software reset failed: %d\n",
> error);
> +               return error;
> +       }
> +
> +       /*
> +        * We should wait at least 10 msec (but no more than 40)
> before
> +        * sending fastboot or IAP command to the device.
> +        */
> +       msleep(30);

If timing is critical in both ways, you should take our guarantee if sufficient sleep. I suggest you sleep 11msecs.

Sorry, this is our firmware tricky but it should be sleep longer than 30ms. Actually 70ms.
(Dmitry, I need to modify this delay time to 70ms. Sorry for the changed over and over again; 
	because we consider big sensor solution which need to use more ICs and need more longer delay)

thanks,
Scott

> +static int elants_i2c_initialize(struct elants_data *ts) {
> +       struct i2c_client *client = ts->client;
> +       int error, retry_cnt;
> +       const u8 hello_packet[] = { 0x55, 0x55, 0x55, 0x55 };
> +       const u8 recov_packet[] = { 0x55, 0x55, 0x80, 0x80 };
> +       u8 buf[HEADER_SIZE];
> +

Strictly speaking you should disable preemption here.


> +       for (retry_cnt = 0; retry_cnt < MAX_RETRIES; retry_cnt++) {
> +               error = elants_i2c_sw_reset(client);
> +               if (error) {
> +                       /* Continue initializing if it's the last try
> */
> +                       if (retry_cnt < MAX_RETRIES - 1)
> +                               continue;
> +               }

	Regards
		Oliver

--
Oliver Neukum <oneukum@suse.de>


