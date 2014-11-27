Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaK0NKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 08:10:34 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:63080 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaK0NKc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 08:10:32 -0500
MIME-Version: 1.0
In-Reply-To: <682b075ae056422683f93be4ea892011@BL2FFO11FD024.protection.gbl>
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
	<1415041531-15520-5-git-send-email-soren.brinkmann@xilinx.com>
	<CACRpkdazagbSZdMvHTggQuAFm9uObn2ARoCwcyM-sspuLTXqkQ@mail.gmail.com>
	<682b075ae056422683f93be4ea892011@BL2FFO11FD024.protection.gbl>
Date: Thu, 27 Nov 2014 14:10:32 +0100
Message-ID: <CACRpkdZfWKonvOfGEzz6bPxjzoBRb72Ydkov9X9YaMLbKiMn-g@mail.gmail.com>
Subject: Re: [PATCH 4/7] pinctrl: zynq: Document DT binding
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 7:53 PM, Sören Brinkmann
<soren.brinkmann@xilinx.com> wrote:
> On Tue, 2014-11-11 at 04:00PM +0100, Linus Walleij wrote:

>> I don't really like that you mix multiplexing and config in the
>> same node. I would prefer if the generic bindings say we have
>> muxing nodes and config nodes, and those are disparate.
>>
>> Can't you just split this:
>>
>> common-mux {
>>     groups = "uart1_10_grp";
>>     function = "uart1";
>> };
>>
>> common-config {
>>     groups = "uart1_10_grp";
>>     slew-rate = <0>;
>>     io-standard = <1>;
>> };
>>
>> That way we can identify nodes as mux nodes (have "function")
>> or config nodes (have "groups" or "pins" but not "function") which
>> I think makes things easier to read.
>
> I think such separation is not required by the bindings currently and
> the parser assumes everything can be present in any node.

The bindings say:

== Generic pin multiplexing node content ==

pin multiplexing nodes:

function                - the mux function to select
groups                  - the list of groups to select with this function

Example:

state_0_node_a {
        function = "uart0";
        groups = "u0rxtx", "u0rtscts";
};
state_1_node_a {
        function = "spi0";
        groups = "spi0pins";
};


== Generic pin configuration node content ==

(...)
Supported generic properties are:

pins                    - the list of pins that properties in the node
                          apply to (either this or "group" has to be
                          specified)
group                   - the group to apply the properties to, if the driver
                          supports configuration of whole groups rather than
                          individual pins (either this or "pins" has to be
                          specified)

It is not explicit that they have to be separate nodes but if needed
we can state that more clearly.

> Can we add that requirement to the generic bindings without breaking
> current users? I think it would make the implementation a little easier.

I think so.

Yours,
Linus Walleij
