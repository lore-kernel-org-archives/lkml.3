Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab3GBIEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 04:04:53 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:51187 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932154Ab3GBIEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 04:04:48 -0400
X-Greylist: delayed 53049 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 04:04:46 EDT
Message-ID: <51D28991.3050704@st.com>
Date: Tue, 02 Jul 2013 10:04:33 +0200
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: srinivas.kandagatla@st.com
Cc: netdev@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] dt:net:stmmac: Add support to dwmac version 3.610
 and 3.710
References: <1372678962-12959-1-git-send-email-srinivas.kandagatla@st.com> <1372679034-13139-1-git-send-email-srinivas.kandagatla@st.com> <51D1BA52.3030201@st.com> <51D27658.1060806@st.com>
In-Reply-To: <51D27658.1060806@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/2013 8:42 AM, Srinivas KANDAGATLA wrote:
> Are you happy with the setting pmt based on compatible string or do you
> think passing pmt as another property to device tree makes more sense?

I prefer to pass pmt as another property but indeed this is not a big
problem because all the new chips have the HW cap. register to fix
at run-time the driver capability.

This field, as others, was really useful on old mac generations where
sometime the PMT was synthesized, sometime not.

The code should be safe enough because if, for example,
we have a new GMAC but w/o the extended module for PMT, so at probing
time the driver will fix all by looking at the HW cap register and
it will be never able to do WoL.

ciao
peppe


