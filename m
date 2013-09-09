Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab3IIEQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 00:16:52 -0400
Received: from mail-vb0-f47.google.com ([209.85.212.47]:53916 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3IIEQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 00:16:51 -0400
MIME-Version: 1.0
In-Reply-To: <CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
References: <1378160418-13898-1-git-send-email-raphael.scarv@gmail.com>
	<87fvtefy10.fsf@mushroom.PK5001Z>
	<CACz=WeeE+jxdaxpR_amF60deDcEy8nChYYfY3UA3CNfhmOB8Gw@mail.gmail.com>
Date: Mon, 9 Sep 2013 01:16:51 -0300
Message-ID: <CACz=Wedn5xD+Zw9DbP3AizCvf5=_LWPPvXJtHc_wgKUvE=_zbw@mail.gmail.com>
Subject: Fwd: [PATCH 1/1] staging/speakup/kobjects.c: Code improvement.
From: Raphael S Carvalho <raphael.scarv@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 12:56 AM, Chris Brannon <chris@the-brannons.com> wrote:
>
> "Raphael S.Carvalho" <raphael.scarv@gmail.com> writes:
>
> > +             /*
> > +             * If voice was just changed, we might need to reset our default
> > +             * pitch and volume.
> > +             */
> > +             if (param->var_id == VOICE) {
> > +                     spk_reset_default_value("pitch", synth->default_pitch,
> > +                             value);
> > +                     spk_reset_default_value("vol", synth->default_vol,
> > +                             value);
>
> There's an "invalid read" bug here.  You didn't introduce it; it has
> been there all along.  It's possible that value contains a value that is
> out of range, in which case, the spk_reset_default_value calls could
> fetch invalid data.  The value of ret should be sufficient for
> determining whether value is in range, so I'd change the condition of
> the if statement to this:


Wouldn't the following code (right before the statement: if
(param->var_id == VOICE))
check if value is out of range?

        value = simple_strtol(cp, NULL, 10);
        ret = spk_set_num_var(value, param, len);

        if (ret == -ERANGE) {
            var_data = param->data;
            pr_warn("value for %s out of range, expect %d to %d\n",
                param->name,
                var_data->u.n.low, var_data->u.n.high);
        }

>
>
>                 if (param->var_id == VOICE && ret != -ERANGE) {
>
> Or possibly better:
>                 if (param->var_id == VOICE && ret == 0) {
>
> I'd say please resend with that fix, or if not, I can send a one-line
> patch to be applied after yours.
>
> -- Chris


Regards,
Raphael S. Carvalho
