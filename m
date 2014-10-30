Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569AbaJ3Tso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:48:44 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53308 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759580AbaJ3Tsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:48:42 -0400
Date: Thu, 30 Oct 2014 20:48:39 +0100
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] pinctrl: add helpers for group based drivers
Message-ID: <20141030194839.GB6764@kwain>
References: <1413792260-4265-1-git-send-email-antoine.tenart@free-electrons.com>
 <1413792260-4265-3-git-send-email-antoine.tenart@free-electrons.com>
 <CACRpkdaPPcUkWrQ8G19igEdDGCXGUGd=utFzny54oRpZ=UNuYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaPPcUkWrQ8G19igEdDGCXGUGd=utFzny54oRpZ=UNuYA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Oct 28, 2014 at 04:38:27PM +0100, Linus Walleij wrote:
> On Mon, Oct 20, 2014 at 10:04 AM, Antoine Tenart
> <antoine.tenart@free-electrons.com> wrote:
> 
> > +#ifdef CONFIG_OF
> > +int of_pinctrl_utils_read_function(struct pinctrl_dev *pctldev,
> > +               struct device_node *node, const char **function_name,
> > +               int *ngroups)
> > +{
> > +       int ret;
> > +
> > +       ret = of_property_read_string(node, "function", function_name);
> > +       if (ret) {
> > +               dev_err(pctldev->dev, "missing function property in node %s\n",
> > +                       node->name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       *ngroups = of_property_count_strings(node, "groups");
> > +       if (ngroups <= 0) {
> > +               dev_err(pctldev->dev, "missing groups property in node %s\n",
> > +                       node->name);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(of_pinctrl_utils_read_function);
> > +#endif
> 
> Isn't it nasty to print dev_err() here if you maybe just want
> to check if this node has a "function" element and proceed to
> see if it's a pin config group in case it hasn't?
> 
> Or should we add of_pinctrl_utils_node_is_mux() and
> of_pinctrl_utils_node_is_config() to check this?

We could have an additional pin_name parameter and return an error if both
function_name *and* pin_name are NULL. That could also allow to have nodes with
both a function and a pin, if that make any sense.

Maybe the of_pinctrl_utils_node_is_mux/config() solution is more
appropriate to avoid having a confusing function. Plus we would have a
dedicated of_pinctrl_utils_read_pins() function.

I think I prefer the second solution because it could avoid some
confusion and the logic would stay in the pinctrl core functions. 

I'll cook up a new version if the of_pinctrl_utils_node_is_mux/config()
is okay with you.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
