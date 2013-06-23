Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab3FWBp6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 21:45:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:35852 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab3FWBp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 21:45:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,921,1363158000"; 
   d="scan'208";a="354176499"
Date: Sun, 23 Jun 2013 09:45:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Raphael S Carvalho <raphael.scarv@gmail.com>
Cc: kbuild@01.org, Julia Lawall <julia.lawall@lip6.fr>,
        Liam Girdwood <lrg@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [kbuild] sound/soc/soc-fw.c:945:9-16: ERROR: se is NULL but
 dereferenced.
Message-ID: <20130623014553.GA10419@localhost>
References: <51c5b942.ZhZXIoNf8EKpybq5%fengguang.wu@intel.com>
 <CACz=WefaSAsB6NYY37WA1x-=VHxQ8Jfbud8xzH3nq1QHzynoaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACz=WefaSAsB6NYY37WA1x-=VHxQ8Jfbud8xzH3nq1QHzynoaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 12:35:44PM -0300, Raphael S Carvalho wrote:
> I'm in a Linux event now, and I can't clone the tree (probably the port for
> that purpose isn't allowed)
> Then I sending a simplified patch that shows which lines must be changed.
 
Patch looks good to me. Thanks!

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

> Signed-off: Raphael S. Carvalho <raphael.scarv@gmail.com>
> 
> --- soc-fw_old.c    2013-06-22 12:13:48.000000000 -0300
> +++ soc-fw_new.c    2013-06-22 12:19:41.000000000 -0300
> @@ -893,7 +893,7 @@
>          if (err < 0) {
>              dev_err(sfw->dev, "ASoC: could not create"
>                  " values for %s\n", ec->hdr.name);
> -            goto err_se;
> +            goto err;
>          }
>          /* fall through to create texts */
>      case SOC_CONTROL_TYPE_ENUM:
> @@ -905,13 +905,13 @@
>          if (err < 0) {
>              dev_err(sfw->dev, "ASoC: could not create"
>                  " texts for %s\n", ec->hdr.name);
> -            goto err_se;
> +            goto err;
>          }
>          break;
>      default:
>          dev_err(sfw->dev, "ASoC: invalid enum control type %d for %s\n",
>              ec->hdr.index, ec->hdr.name);
> -        goto err_se;
> +        goto err;
>      }
> 
>      /* map standard io handlers and check for external handlers */
> @@ -928,21 +928,19 @@
>                  SOC_CONTROL_GET_ID_GET(ec->hdr.index),
>                  SOC_CONTROL_GET_ID_PUT(ec->hdr.index),
>                  SOC_CONTROL_GET_ID_INFO(ec->hdr.index));
> -            goto err_se;
> +            goto err;
>          }
> 
>          err = soc_fw_init_kcontrol(sfw, kc);
>          if (err < 0) {
>              dev_err(sfw->dev, "ASoC: failed to init %s\n",
>                  ec->hdr.name);
> -            goto err_se;
> +            goto err;
>          }
>      }
>      return kc;
> 
> -err_se:
> -    kfree(kc);
> -
> +err:
>      /* free values and texts */
>      if (se->dvalues)
>          kfree(se->dvalues);
> @@ -950,7 +948,8 @@
>          kfree(se->dtexts[i]);
> 
>      kfree(se);
> -
> +err_se:
> +    kfree(kc);
>      return NULL;
>  }
> 
> 
> 
> On Sat, Jun 22, 2013 at 11:48 AM, Fengguang Wu <fengguang.wu@intel.com>wrote:
> 
> > TO: Liam Girdwood <lrg@ti.com>
> > CC: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >
> >
> > Hi Liam,
> >
> > FYI, there are coccinelle warnings in
> >
> > tree:   git://gitorious.org/omap-audio/linux-audiopeter/topic/ti-audio-next-bnw-wip
> > head:   ac1981249f0c606cede98d6dab091ecb1ae480c9
> > commit: 6d98dbbcfb5da2176b3e60faaf86d2279790fe67 ASoC: firmware: Add
> > support for dynamic components
> > date:   5 weeks ago
> > :::::: branch date: 5 days ago
> > :::::: commit date: 5 weeks ago
> >
> > >> sound/soc/soc-fw.c:945:9-16: ERROR: se is NULL but dereferenced.
> > --
> > >> sound/soc/soc-fw.c:1523:8-9: ERROR: reference preceded by free on line
> > 1523
> > >> sound/soc/soc-fw.c:1443:8-9: ERROR: reference preceded by free on line
> > 1443
> > >> sound/soc/soc-fw.c:1483:8-9: ERROR: reference preceded by free on line
> > 1483
> > --
> > >> sound/soc/soc-fw.c:1528:6-8: ERROR: invalid reference to the index
> > variable of the iterator on line 1513
> > >> sound/soc/soc-fw.c:1448:6-8: ERROR: invalid reference to the index
> > variable of the iterator on line 1433
> > >> sound/soc/soc-fw.c:1488:6-8: ERROR: invalid reference to the index
> > variable of the iterator on line 1473
> >
> > git remote add omap-audio git://gitorious.org/omap-audio/linux-audio
> > git remote update omap-audio
> > git checkout 6d98dbbcfb5da2176b3e60faaf86d2279790fe67
> > vim +945 sound/soc/soc-fw.c
> >
> > 6d98dbbc Liam Girdwood 2012-12-05  929                          goto
> > err_se;
> > 6d98dbbc Liam Girdwood 2012-12-05  930                  }
> > 6d98dbbc Liam Girdwood 2012-12-05  931
> > 6d98dbbc Liam Girdwood 2012-12-05  932                  err =
> > soc_fw_init_kcontrol(sfw, kc);
> > 6d98dbbc Liam Girdwood 2012-12-05  933                  if (err < 0) {
> > 6d98dbbc Liam Girdwood 2012-12-05  934
> >  dev_err(sfw->dev, "ASoC: failed to init %s\n",
> > 6d98dbbc Liam Girdwood 2012-12-05  935
> >  ec->hdr.name);
> > 6d98dbbc Liam Girdwood 2012-12-05  936                          goto
> > err_se;
> > 6d98dbbc Liam Girdwood 2012-12-05  937                  }
> > 6d98dbbc Liam Girdwood 2012-12-05  938          }
> > 6d98dbbc Liam Girdwood 2012-12-05  939          return kc;
> > 6d98dbbc Liam Girdwood 2012-12-05  940
> > 6d98dbbc Liam Girdwood 2012-12-05  941  err_se:
> > 6d98dbbc Liam Girdwood 2012-12-05  942          kfree(kc);
> > 6d98dbbc Liam Girdwood 2012-12-05  943
> > 6d98dbbc Liam Girdwood 2012-12-05  944          /* free values and texts */
> > 6d98dbbc Liam Girdwood 2012-12-05 @945          if (se->dvalues)
> > 6d98dbbc Liam Girdwood 2012-12-05  946                  kfree(se->dvalues);
> > 6d98dbbc Liam Girdwood 2012-12-05  947          for (i = 0; i < ec->max;
> > i++)
> > 6d98dbbc Liam Girdwood 2012-12-05  948
> >  kfree(se->dtexts[i]);
> > 6d98dbbc Liam Girdwood 2012-12-05  949
> > 6d98dbbc Liam Girdwood 2012-12-05  950          kfree(se);
> > 6d98dbbc Liam Girdwood 2012-12-05  951
> > 6d98dbbc Liam Girdwood 2012-12-05  952          return NULL;
> > 6d98dbbc Liam Girdwood 2012-12-05  953  }
> >
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology
> > Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel
> > Corporation
> > _______________________________________________
> > kbuild mailing list
> > kbuild@lists.01.org
> > https://lists.01.org/mailman/listinfo/kbuild
> >
