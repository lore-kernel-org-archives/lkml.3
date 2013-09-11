Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383Ab3IKLeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:34:50 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15301 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044Ab3IKLes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:34:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 11 Sep 2013 04:31:43 -0700
Message-ID: <52305587.6020207@nvidia.com>
Date: Wed, 11 Sep 2013 19:35:35 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
References: <522E93D6.2010304@roeck-us.net> <522E94AE.7000804@wwwdotorg.org> <522E97CE.4070300@roeck-us.net> <522E9C84.9070405@wwwdotorg.org> <20130910100939.GW29403@sirena.org.uk> <522F35BF.6070909@wwwdotorg.org> <20130910170438.GS29403@sirena.org.uk> <522F5A65.8040907@wwwdotorg.org> <20130910181837.GD29403@sirena.org.uk> <522F66FB.2000608@wwwdotorg.org> <20130910185235.GF29403@sirena.org.uk>
In-Reply-To: <20130910185235.GF29403@sirena.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 02:52 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Sep 10, 2013 at 12:37:47PM -0600, Stephen Warren wrote:
> 
>> OK, so for the DT binding we should make vcc-supply a required
>> property, yet the driver will still work OK if that property just
>> happens to be missing (or e.g. when instantiated from a board file,
>> and there's no regulator).
> 
> Yup.  That way we've got both the binding and code trying to make things
> work, hopefully that'll maximise robustness.

Ok, it looks like regulator_get will handle all things, looking forward
to your patches :)
Then I think my changes will be simple, just something like:
+	reg = devm_regulator_get(dev, "vcc");
+	if (!IS_ERR(reg)) {
+		err = regulator_enable(reg);
+		if (err < 0)
+			return err;
+	} else {
+		return PTR_ERR(reg);
+	}

Wei.

> 
> * Unknown Key
> * 0x7EA229BD
> 

