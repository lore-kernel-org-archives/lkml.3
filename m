Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaL3EnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:43:18 -0500
Received: from mail-by2on0118.outbound.protection.outlook.com ([207.46.100.118]:46920
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751483AbaL3EnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:43:16 -0500
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "jmmahler@gmail.com" <jmmahler@gmail.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        "bleung@google.com" <bleung@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Solda <dso@cypress.com>
Subject: RE: [PATCH v16 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Thread-Topic: [PATCH v16 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Thread-Index: AQHQGqmetkDN8Qps7UOAK3pR2L8R8pynZEcAgAAcL8A=
Date: Tue, 30 Dec 2014 04:43:13 +0000
Message-ID: <BN1PR06MB070348FFC33EC8024C5D17BD15E0@BN1PR06MB070.namprd06.prod.outlook.com>
References: <1418896856-15766-1-git-send-email-dudl@cypress.com>
 <1418896856-15766-2-git-send-email-dudl@cypress.com>
 <20141230010612.GK9565@dtor-ws>
In-Reply-To: <20141230010612.GK9565@dtor-ws>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.95.211.187]
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=dudl@cypress.com; 
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1084;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0601MB1084;
x-forefront-prvs: 04410E544A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(41574002)(51704005)(13464003)(51164003)(189002)(164054003)(24454002)(199003)(105586002)(46102003)(68736005)(122556002)(74316001)(2656002)(87936001)(20776003)(106116001)(62966003)(77156002)(102836002)(97736003)(66066001)(2900100001)(2950100001)(64706001)(31966008)(107046002)(54206007)(40100003)(54356999)(21056001)(4396001)(76176999)(101416001)(99396003)(50986999)(76576001)(120916001)(33656002)(19580395003)(106356001)(110136001)(19580405001)(86362001)(54606007)(92566001)(99286002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0601MB1084;H:BN1PR06MB070.namprd06.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Dec 2014 04:43:13.7964
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0601MB1084
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry,

Thanks a lot for your review and detail comments.

Please see my replies below.

Thanks,
Dudley

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: 2014?12?30? 9:06
> To: Dudley Du
> Cc: jmmahler@gmail.com; rydberg@euromail.se; bleung@google.com;
> linux-input@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v16 01/12] input: cyapa: re-design driver to support
> multi-trackpad in one driver
>
> Hi Dudley,
>
> On Thu, Dec 18, 2014 at 06:00:45PM +0800, Dudley Du wrote:
> > In order to support multiple different chipsets and communication protocols
> > trackpad devices in one cyapa driver, the new cyapa driver is re-designed
> > with one cyapa driver core and multiple device specific functions component.
> > The cyapa driver core is contained in this patch, it supplies basic functions
> > that working with kernel and input subsystem, and also supplies the interfaces
> > that the specific devices' component can connect and work together with as
> > one driver.
> > TEST=test on Chromebooks.
>
> Thank you for making changes to the driver. It shapes up nicely, still
> I have a few comments:
>
> 1. I'd rather we did not check for presence of various methods in ops
> structure but rather rely on providers to supply stubs if they do not
> need actual implementation (see a draft of a patch below).
>
I will supply stubs for both in the ops structure.

> 2. Please consider changing CYAPA_BOOTLOADER() and friends to be static
> inline functions (like cyapa_is_bootloader_mode())- it provides better
> type checking.
>
I will supply statci inlie function cyapa_is_bootloader_mode() and
cyapa_is_operational_mode() instead of CYAPA_BOOTLOADER() and CYAPA_OPERATIONAL()

> 3. The ops->initialize() method should be called after we determine the
> generation of the device, not before.
>
No, it cannot be called after we determine the generation of the device.
Because the ops->initialize() is used to prepare the communication status for the driver.
It will initialize and parpare the communication for gen5 command process which
will be used in cyapa_detect() when detecting gen5, so It cannot be called after
we determine the generation of the device.

> 4. I wonder why cyapa_read_block() is in gen3 file and not in main file
> - it seems it is used by generic code?
>
cyapa_read_block() is mainly used to read block data from gen3 TP.
It is used in both main file and gen3 file.
And this function will use static variables cyapa_smbus_cmd[] and cyapa_i2c_cmds[]
which are dedicated to gen3 TP and defined in gen3 file, so I think it should be put
in the gen3 file instead of in main file to avoid put the variables
cyapa_smbus_cmd[] and cyapa_i2c_cmds[] into main file.
That why put it in gen3 file.

> 5. Is bootloader mode different between gen3 and gen5 devices? Or should
> you detect and handle bootloader mode directly in the core, maybe as a
> "fake generation"?
>
Yes, the bootloader mode is completely different between gen3 and gen5 device.
No protocol or mechanism could be shared.

For detect and handle bootloader mode directly in the core,
do you mean add the function to exit bootloader mode as do for firmware update?
Currently, the bootloader operation porcess of firmware update is abstracted
into cyapa_firmware() and put it in the core, other operations that are dedicated to gen3/gen5
TP device are seperated in to gen3/gen5 file.

> Thanks!
>
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/Makefile     |    3 +-
> >  drivers/input/mouse/cyapa.c      | 1047 ++++++++++++++------------------------
> >  drivers/input/mouse/cyapa.h      |  307 +++++++++++
> >  drivers/input/mouse/cyapa_gen3.c |  801 +++++++++++++++++++++++++++++
> >  4 files changed, 1492 insertions(+), 666 deletions(-)
> >  create mode 100644 drivers/input/mouse/cyapa.h
> >  create mode 100644 drivers/input/mouse/cyapa_gen3.c
> >
> > diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
.......
> > +
> > +.irq_handler = cyapa_gen3_irq_handler,
> > +.irq_cmd_handler = cyapa_gen3_irq_cmd_handler,
> > +
> > +.set_power_mode = cyapa_gen3_set_power_mode,
> > +};
> > --
> > 1.9.1
> >
>
> --
> Dmitry
>
> Input: cyapa - misc changes
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/input/mouse/cyapa.c |   50 ++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index ae1df15..27ae5e61 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -36,10 +36,8 @@ const char product_id[] = "CYTRA";
>  static int cyapa_reinitialize(struct cyapa *cyapa);
>
>  /* Returns 0 on success, else negative errno on failure. */
> -static ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len,
> -u8 *values)
> +static int cyapa_i2c_read(struct cyapa *cyapa, u8 reg, size_t len, u8 *values)
>  {
> -int ret;
>  struct i2c_client *client = cyapa->client;
>  struct i2c_msg msgs[] = {
>  {
> @@ -55,9 +53,9 @@ static ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg,
> size_t len,
>  .buf = values,
>  },
>  };
> +int ret;
>
> -ret = i2c_transfer(client->adapter, msgs, 2);
> -
> +ret = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
>  if (ret != ARRAY_SIZE(msgs))
>  return ret < 0 ? ret : -EIO;
>
> @@ -73,21 +71,24 @@ static ssize_t cyapa_i2c_read(struct cyapa *cyapa, u8 reg,
> size_t len,
>   *
>   * Return negative errno code on error; return zero when success.
>   */
> -static ssize_t cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
> +static int cyapa_i2c_write(struct cyapa *cyapa, u8 reg,
>   size_t len, const void *values)
>  {
> -int ret;
>  struct i2c_client *client = cyapa->client;
>  char buf[32];
> +int ret;
>
> -if (len > 31)
> +if (len > sizeof(buf) - 1)
>  return -ENOMEM;
>
>  buf[0] = reg;
>  memcpy(&buf[1], values, len);
> +
>  ret = i2c_master_send(client, buf, len + 1);
> +if (ret != len + 1)
> +return ret < 0 ? ret : -EIO;
>
> -return (ret == (len + 1)) ? 0 : ((ret < 0) ? ret : -EIO);
> +return 0;
>  }
>
>  static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
> @@ -143,7 +144,7 @@ static int cyapa_get_state(struct cyapa *cyapa)
>  goto error;
>
>  /*
> - * Detect trackpad protocol based on characristic registers and bits.
> + * Detect trackpad protocol based on characteristic registers and bits.
>   */
>  do {
>  cyapa->status[REG_OP_STATUS] = status[REG_OP_STATUS];
> @@ -206,11 +207,15 @@ int cyapa_poll_state(struct cyapa *cyapa, unsigned int
> timeout)
>  int error;
>  int tries = timeout / 100;
>
> -error = cyapa_get_state(cyapa);
> -while ((error || cyapa->state <= CYAPA_STATE_BL_BUSY) && tries--) {
> -msleep(100);
> +do {
>  error = cyapa_get_state(cyapa);
> -}
> +// FIXME: I think it would be better if cyapa_get_state()
> +// returned -EAGAIN when bootloader is busy

Thanks, I would like to add below code to check the BL_BUSY state before cyapa_get_state() return.
out_detected:
if (cyapa->state <= CYAPA_STATE_BL_BUSY)
return -EAGAIN;
return 0;

> +if (!error && cyapa->state > CYAPA_STATE_BL_BUSY)
> +return 0;
> +
> +msleep(100);
> +} while (tries--);
>
>  return (error == -EAGAIN || error == -ETIMEDOUT) ? -ETIMEDOUT : error;
>  }
> @@ -294,7 +299,7 @@ static int cyapa_open(struct input_dev *input)
>  if (error)
>  return error;
>
> -if (cyapa->operational && cyapa->ops->set_power_mode) {
> +if (cyapa->operational) {
>  /*
>   * though failed to set active power mode,
>   * but still may be able to work in lower scan rate
> @@ -329,7 +334,8 @@ static void cyapa_close(struct input_dev *input)
>  mutex_lock(&cyapa->state_sync_lock);
>
>  disable_irq(client->irq);
> -if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
> +
> +if (!CYAPA_BOOTLOADER(cyapa))
>  cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
>
>  mutex_unlock(&cyapa->state_sync_lock);
> @@ -484,7 +490,7 @@ static int cyapa_initialize(struct cyapa *cyapa)
>  return error;
>
>  /* Power down the device until we need it. */
> -if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
> +if (!CYAPA_BOOTLOADER(cyapa))
>  cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
>
>  return 0;
> @@ -497,7 +503,7 @@ static int cyapa_reinitialize(struct cyapa *cyapa)
>  int error;
>
>  /* Avoid command failures when TP was in OFF state. */
> -if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
> +if (!CYAPA_BOOTLOADER(cyapa))
>  cyapa->ops->set_power_mode(cyapa, PWR_MODE_FULL_ACTIVE, 0);
>
>  error = cyapa_detect(cyapa);
> @@ -516,7 +522,7 @@ static int cyapa_reinitialize(struct cyapa *cyapa)
>  out:
>  if (!input || !input->users) {
>  /* Reset to power OFF state to save power when no user open. */
> -if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode)
> +if (!CYAPA_BOOTLOADER(cyapa))
>  cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
>  }
>
> @@ -647,9 +653,9 @@ static int __maybe_unused cyapa_suspend(struct device
> *dev)
>   * Set trackpad device to idle mode if wakeup is allowed,
>   * otherwise turn off.
>   */
> -power_mode = device_may_wakeup(dev) ? cyapa->suspend_power_mode
> -    : PWR_MODE_OFF;
> -if (!CYAPA_BOOTLOADER(cyapa) && cyapa->ops->set_power_mode) {
> +if (!CYAPA_BOOTLOADER(cyapa)) {
> +power_mode = device_may_wakeup(dev) ?
> +cyapa->suspend_power_mode : PWR_MODE_OFF;
>  error = cyapa->ops->set_power_mode(cyapa, power_mode,
>  cyapa->suspend_sleep_time);
>  if (error)


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
