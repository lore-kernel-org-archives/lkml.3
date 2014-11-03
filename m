Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaKCQKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:10:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57661 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaKCQKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:10:45 -0500
Date: Mon, 3 Nov 2014 10:10:11 -0600
From: Felipe Balbi <balbi@ti.com>
To: Kiran Raparthy <kiran.kumar@linaro.org>
CC: Felipe Balbi <balbi@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Todd Poynor <toddpoynor@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Arve =?utf-8?B?SGrvv71ubmV277+9Zw==?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Subject: Re: [RFC v4] usb: phy: Hold wakeupsource when USB is enumerated in
 peripheral mode
Message-ID: <20141103161011.GL27425@saruman>
Reply-To: <balbi@ti.com>
References: <1412673344-25443-1-git-send-email-kiran.kumar@linaro.org>
 <20141007142554.GE24720@saruman>
 <CA+RfmHaNpQRpEJmZLUHrYPfizS0w+bbeG+SVsFXOA-5jbXS_Wg@mail.gmail.com>
 <20141010152044.GG31348@saruman>
 <CA+RfmHbA8WAE+RLNTBKD3BC+TM3OzS1+psaO28pBCS1S9NxWmQ@mail.gmail.com>
 <CA+RfmHZ5nJZ6bYDQ+bWQfPTBpiabRkEiXKzkfntXamtJj9kJuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ucfHZChuBC0NsER/"
Content-Disposition: inline
In-Reply-To: <CA+RfmHZ5nJZ6bYDQ+bWQfPTBpiabRkEiXKzkfntXamtJj9kJuQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ucfHZChuBC0NsER/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 31, 2014 at 09:27:43AM +0530, Kiran Raparthy wrote:
> >>> Thank you very much for taking time in reviewing the patch.
> >>> I will try to improve the patch as per your suggestions.
> >>> however,i have few queries which i wanted to understand from you.
> >>
> >> sure thing.
> >>
> >>> On 7 October 2014 19:55, Felipe Balbi <balbi@ti.com> wrote:
> >>> >> +static int otg_wakeupsource_init(void)
> >>> >> +{
> >>> >> +     int ret_usb2;
> >>> >> +     int ret_usb3;
> >>> >> +     char wsource_name_usb2[40];
> >>> >> +     char wsource_name_usb3[40];
> >>> >> +     static struct usb_phy *otgws_xceiv_usb2;
> >>> >> +     static struct usb_phy *otgws_xceiv_usb3;
> >>> >> +
> >>> >> +     otgws_xceiv_usb2 =3D usb_get_phy(USB_PHY_TYPE_USB2);
> >>> >> +     otgws_xceiv_usb3 =3D usb_get_phy(USB_PHY_TYPE_USB3);
> >>> >> +
> >>> >> +     if (IS_ERR(otgws_xceiv_usb2) && IS_ERR(otgws_xceiv_usb3)) {
> >>> >> +             pr_err("%s: No OTG transceiver found\n", __func__);
> >>> >> +             return PTR_ERR(otgws_xceiv_usb2);
> >>> >> +     }
> >>> >> +
> >>> >> +     spin_lock_init(&otgws_xceiv_usb2->otgws_slock);
> >>> >> +     spin_lock_init(&otgws_xceiv_usb3->otgws_slock);
> >>> >> +
> >>> >> +     snprintf(wsource_name_usb2, sizeof(wsource_name_usb2),
> >>> >> "vbus-%s",
> >>> >> +             dev_name(otgws_xceiv_usb2->dev));
> >>> >> +     wakeup_source_init(&otgws_xceiv_usb2->wsource,
> >>> >> wsource_name_usb2);
> >>> >> +
> >>> >> +     snprintf(wsource_name_usb3, sizeof(wsource_name_usb3),
> >>> >> "vbus-%s",
> >>> >> +             dev_name(otgws_xceiv_usb3->dev));
> >>> >> +     wakeup_source_init(&otgws_xceiv_usb3->wsource,
> >>> >> wsource_name_usb3);
> >>> >> +
> >>> >> +     otgws_xceiv_usb2->otgws_nb.notifier_call =3D
> >>> >> otgws_otg_usb2_notifications;
> >>> >> +     ret_usb2 =3D usb_register_notifier(otgws_xceiv_usb2,
> >>> >> +                                     &otgws_xceiv_usb2->otgws_nb);
> >>> >> +
> >>> >> +     otgws_xceiv_usb3->otgws_nb.notifier_call =3D
> >>> >> otgws_otg_usb3_notifications;
> >>> >> +     ret_usb3 =3D usb_register_notifier(otgws_xceiv_usb3,
> >>> >> +                                     &otgws_xceiv_usb3->otgws_nb);
> >>> >> +
> >>> >> +     if (ret_usb2 && ret_usb3) {
> >>> >> +             pr_err("%s: usb_register_notifier on transceiver
> >>> >> failed\n",
> >>> >> +                      __func__);
> >>> >> +             wakeup_source_trash(&otgws_xceiv_usb2->wsource);
> >>> >> +             wakeup_source_trash(&otgws_xceiv_usb3->wsource);
> >>> >> +             otgws_xceiv_usb2 =3D NULL;
> >>> >> +             otgws_xceiv_usb3 =3D NULL;
> >>> >> +             return ret_usb2 | ret_usb3;
> >>> >> +     }
> >>> >> +
> >>> >> +     return 0;
> >>> >> +}
> >>> >> +
> >>> >> +late_initcall(otg_wakeupsource_init);
> >>> >
> >>> > you guys are really not getting what I mean. I asked for this to be
> >>> > built into the core itself. This means that you shouldn't need to u=
se
> >>> > notifications nor should you need to call usb_get_phy(). You're par=
t of
> >>> > the PHY framework.
> >>> >
> >>> > All this late_initcall() nonsense should go.
> >>> >
> >>> > This code won't even work if we have more than one phy of the same =
type
> >>> > (AM437x SoC, for example, has up to 4 instances of dwc3, so that's 4
> >>> > USB2 PHYs), because you can't grab the PHY you want.
> >>>
> >>> Apologies,I am new to usb sub system,so i missed this point before i
> >>> posted my patch,Thanks for the information.
> >>
> >> np.
> >>
> >>> > What you need is to:
> >>> >
> >>> > 1) make PHY notifiers generic (move all of that phy-core.c)
> >>> From the above points,you mentioned that "if we built it into core,we
> >>> shouldn't need to use notifications"
> >>> and your first point here says that make phy notifiers generic in
> >>> phy-core.c
> >>> can you help me understanding it better so that there wont be any
> >>> understanding gap.
> >>
> >> yeah, notifiers should go but if you really must use them, then at lea=
st
> >> make all of that generic ;-)
> >>
> >>> > 2) introduce usb_phy_set_event(phy, event) (which just sets the eve=
n to
> >>> > a
> >>> >         phy->event member for now)
> >>> > 3) make all PHY drivers use usb_phy_set_event()
> >>> > 4) add the following to usb_phy_set_event()
> >>> >
> >>> >         switch (event) {
> >>> >         case USB_EVENT_ENUMERATED:
> >>> >                 pm_stay_awake(&otgws_xceiv->wsource);
> >>> >                 break;
> >>> >
> >>> >         case USB_EVENT_NONE:
> >>> >         case USB_EVENT_VBUS:
> >>> >         case USB_EVENT_ID:
> >>> >         case USB_EVENT_CHARGER:
> >>> >                 pm_wakeup_event(&otgws_xceiv->wsource,
> >>> >                                 msecs_to_jiffies(TEMPORARY_HOLD_TIM=
E));
> >>> >                 break;
> >>> >
> >>> >         default:
> >>> >                 break;
> >>> >         }
> >>> >
> >>> Once the phy drivers receives per-PHY event notification(if we use
> >>> notifier,else "for any event") we can call usb_phy_set_event from phy
> >>> driver to hold the wakeup source.
> >>> Please correct me if my understanding is incorrect.
> >>
> >> yeah. In fact, you can call usb_phy_set_event() directly from PHY's IRQ
> >> handler.
> >>
> >>> I have gone through some phy drivers in drivers/phy,since the each
> >>> driver implementation is different from others, i didn't get the best
> >>> place in  PHY driver
> >>> where we can trigger(use phy-core functionality) per-PHY notifier
> >>> registration. any pointers here?
> >>
> >> registration ? probe(), they all have probe() functions. Now to figure
> >> out where to call usb_phy_set_event(). That's something completely
> >> different, and that's where the core of this change is :-)
> >>
> >> For PHYs which have IRQ lines, easy: just call usb_phy_set_event() from
> >> IRQ handler. For those who don't, then it's a little more difficult and
> >> will require your investigation.
> >
> just a gentle reminder, can you have a look at below points and share
> your thoughts?

Send the patch, I have reviewed this multiple times and all those
comments are archived on multiple mailing list archives. Just read them
again if you need.

--=20
balbi

--ucfHZChuBC0NsER/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6jjAAoJEIaOsuA1yqREhEUP/27NW3EcKXrxUfch9neqPTXw
k0NygRfixH9jsC/QQze86VoAk0594KZpZm3+I5xz01dXwGBkg0pekl49YB/7BOY/
O6c9jDac+MwfVoC819/6MOnnpMqnAHxITx4pIpqL4Q9NP5xNDmnhyr/q153yxoyU
ViVJxrwpsoKpLg1GtBNnAruG23ydU+oRRy/DumxzXhj4i8MXvfgm5ThSlWgoeSCg
hS7qWCkkTwkdrBJYTKRAEKNH+47u3OBAXAkORLjjzPVAdmCOKodZfL/GM5YUYLNe
sPchnAgOZF4Eu1C0VqiJEDu1l0ZtRyxZzbaB7X27qK340snu4kiSvYzRa9w20dsl
OjZIo3G0SQmFSYVz+mPqrwTK/173VI4BwNCghuCVxo+45CDzUsTqIbNVfUwuwsjR
9z5dmUrraVldQdCSlbq7nr9gnD2vaYuEr99Frc/yGzGt9m8pyTyTQuniX7gj/7lo
cSdzxQGYTMJkdewxrjkLq0IoXhLN9ZFnWt13uH7tk37/TPfZx6SLSWxvOki4qSOK
2/pJyzi9FNSngokOFEJFiyiyM6+c9n8npd1RQD7cg14rF/WNwoj8yQ9oZRDvaQAR
FK+2bb4jCaZM0FOTL68mTHgB7Yso0sLf2AaXaW4LFXFnPSNhnJNN8N5AEhl3nNcH
kWmWEnXZEFrMF16ANP+6
=bEjR
-----END PGP SIGNATURE-----

--ucfHZChuBC0NsER/--
