Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaFJOd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:33:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFJOdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:33:55 -0400
Date: Tue, 10 Jun 2014 10:33:44 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: dianders@chromium.org, lee.jones@linaro.org
Subject: Re: i2c: ChromeOS EC tunnel driver
Message-ID: <20140610143344.GA15699@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dianders@chromium.org, lee.jones@linaro.org
References: <20140606193128.CB477660FB4@gitolite.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606193128.CB477660FB4@gitolite.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 07:31:28PM +0000, Linux Kernel wrote:
 > Gitweb:     http://git.kernel.org/linus/;a=commit;h=9d230c9e4f4e67cb1c1cb9e0f6142da16b0f2796
 > Commit:     9d230c9e4f4e67cb1c1cb9e0f6142da16b0f2796
 > Parent:     5271db29d7199fe0ffb303ca4bbbb1485bba28c3
 > Refname:    refs/heads/next
 > Author:     Doug Anderson <dianders@chromium.org>
 > AuthorDate: Wed Apr 30 10:44:09 2014 -0700
 > Committer:  Lee Jones <lee.jones@linaro.org>
 > CommitDate: Tue Jun 3 08:11:49 2014 +0100

 > +static int ec_i2c_construct_message(u8 *buf, const struct i2c_msg i2c_msgs[],
 > +				    int num, u16 bus_num)
 > +{
 > +	struct ec_params_i2c_passthru *params;
 > +	u8 *out_data;
 > +	int i;
 > +
 > +	out_data = buf + sizeof(struct ec_params_i2c_passthru) +
 > +		   num * sizeof(struct ec_params_i2c_passthru_msg);
 > +
 > +	params = (struct ec_params_i2c_passthru *)buf;
 > +	params->port = bus_num;
 > +	params->num_msgs = num;
 > +	for (i = 0; i < num; i++) {
 > +		const struct i2c_msg *i2c_msg = &i2c_msgs[i];
 > +		struct ec_params_i2c_passthru_msg *msg = &params->msg[i];
 > +
 > +		msg->len = i2c_msg->len;
 > +		msg->addr_flags = i2c_msg->addr;
 > +
 > +		if (i2c_msg->flags & I2C_M_TEN)
 > +			msg->addr_flags |= EC_I2C_FLAG_10BIT;

This is a fun bug. EC_I2C_FLAG_10BIT is 1<<16, but msg->addr_flags is only a uint16.

	Dave

