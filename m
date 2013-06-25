Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3FYP2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 11:28:45 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:33953 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3FYP2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 11:28:42 -0400
MIME-Version: 1.0
In-Reply-To: <51C4C2ED.5090505@wwwdotorg.org>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
	<1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
	<51BA3BC1.3090109@wwwdotorg.org>
	<20130614091241.GA23745@ab42.lan>
	<51C1F42E.5090107@wwwdotorg.org>
	<51C1F82C.4020502@wwwdotorg.org>
	<20130620115710.GB942@ab42.lan>
	<51C4C2ED.5090505@wwwdotorg.org>
Date: Tue, 25 Jun 2013 17:28:41 +0200
Message-ID: <CACRpkdZQ=G=K6g25gwGKfS1dCrDS35XepaOs38N-ymEuR0+x=g@mail.gmail.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Christian Ruppert <christian.ruppert@abilis.com>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:17 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> And finally, I don't really like using pin groups for the purpose of
> defining these mappings, since I intended them to purely represent the
> mapping from register fields to the set of affected pins. However, I can
> see an argument for doing this, since the pin groups are in fact still
> representing /some/ aspect of the pinctrl internal HW.

The groups concept was part of the first pinctrl commit
2744e8afb3b76343e7eb8197e8b3e085036010a5
and there the intention was clearly just to define a discrete
set of pins.

And some drivers use it like this still, with no connection to
physical registers, i.MX come to mind.

But I do seem to recall some endless discussions about this,
I think we need to agree to disagree.

I never saw any heavy reason for the driver not to define groups
in some way it seemed would fit the muxing purposes right, we could
say, if we compare to mathematical philiosophy, that I am a formalist
rather than a platonist (i.e. I'm not requiring the description to strictly
match a reality, but rather prefer that they fulfil a practical purpose).
Here is an item for vacation reading...
http://en.wikipedia.org/wiki/Philosophy_of_mathematics

Maybe I will switch schools one day who knows.

Here is a tongue-in-cheek patch making fun of the whole debate:

diff --git a/include/linux/pinctrl/pinctrl.h b/include/linux/pinctrl/pinctrl.h
index 5979147..d3ad8b0 100644
--- a/include/linux/pinctrl/pinctrl.h
+++ b/include/linux/pinctrl/pinctrl.h
@@ -102,6 +102,21 @@ struct pinctrl_ops {
 };

 /**
+ * enum pinctrl_school - define the interpretation of group concept
+ * @PINCTRL_SCHOOL_PLATONIST: the group concept represents the authors
+ *    idea of a reality "behind" the pin controller, though in data
+ *    sheets and registers we may only see shadows of this reality
+ *    reflected as cavernous shades
+ * @PINCTRL_SCHOOL_FORMALIST: the group concept represents the authors
+ *    practical needs of dealing with pins in ordered groups and nothing
+ *    else
+ */
+enum pinctrl_school {
+    PINCTRL_SCHOOL_PLATONIST,
+    PINCTRL_SCHOOL_FORMALIST,
+};
+
+/**
  * struct pinctrl_desc - pin controller descriptor, register this to pin
  * control subsystem
  * @name: name for the pin controller
@@ -115,6 +130,7 @@ struct pinctrl_ops {
  * @confops: pin config operations vtable, if you support pin configuration in
  *    your driver
  * @owner: module providing the pin controller, used for refcounting
+ * @school: which philosophical school the controller belongs to.
  */
 struct pinctrl_desc {
     const char *name;
@@ -124,6 +140,7 @@ struct pinctrl_desc {
     const struct pinmux_ops *pmxops;
     const struct pinconf_ops *confops;
     struct module *owner;
+    enum pinctrl_school school;
 };

 /* External interface to pin controller */

Yours,
Linus Walleij
