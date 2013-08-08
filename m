Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098Ab3HHR7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:59:31 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55770 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758006Ab3HHR71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:59:27 -0400
Date: Thu, 8 Aug 2013 10:59:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Wei Ni <wni@nvidia.com>, khali@linux-fr.org, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
Message-ID: <20130808175932.GB15013@roeck-us.net>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <520359E9.1000600@roeck-us.net>
 <5203D5B6.3060806@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5203D5B6.3060806@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 11:30:30AM -0600, Stephen Warren wrote:
> On 08/08/2013 02:42 AM, Guenter Roeck wrote:
> > On 08/07/2013 11:56 PM, Wei Ni wrote:
> >> The device lm90 can be controlled by the vdd rail.
> >> Adding the power control support to power on/off the vdd rail.
> >> And make sure that power is enabled before accessing the device.
> 
> >> diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
> 
> >>   static int lm90_probe(struct i2c_client *client,
> >>                 const struct i2c_device_id *id)
> >>   {
> >> @@ -1406,6 +1434,20 @@ static int lm90_probe(struct i2c_client *client,
> >>       i2c_set_clientdata(client, data);
> >>       mutex_init(&data->update_lock);
> >>
> >> +    data->lm90_reg = regulator_get(&client->dev, "vdd");
> > 
> > You should use devm_regulator_get(). Then you also don't need the call
> > to regulator_put().
> > 
> >> +    if (IS_ERR_OR_NULL(data->lm90_reg)) {
> > 
> > The function never returns NULL except if the regulator subsystem is not
> > configured,
> > so IS_ERR() is more appropriate.
> > 
> > If the regulator subsystem is not configured, you especially don't need
> > or want
> > to pollute the log with an error message.
> 
> DT parsing errors should be reported. However, if there's nothing to
> parse, it's not an error.
> 
> So, I think this should report an error message *if* there is a DT
> property that defines the regulator to use. If there's no property, just
> use no regulator. If there is a property, it had better be possible to
> parse it.
> 
Agreed.

Guenter
