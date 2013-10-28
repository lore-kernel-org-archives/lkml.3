Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab3J1F66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 01:58:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34095 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3J1F6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 01:58:55 -0400
Date: Mon, 28 Oct 2013 16:58:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?IlZpbGxlIFN5cmrDpGzDpCI=?= 
	<ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131028165848.3ed5f1d9138d215a0769bb0b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_16_58_48_+1100_3+5m/diQvMpQseTe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_16_58_48_+1100_3+5m/diQvMpQseTe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_drv.h between commit e1264ebe9ff4 ("Revert
"drm/i915: Delay disabling of VGA memory until vgacon->fbcon handoff is
done"") from Linus' tree and commits 5f1aae65cdae ("drm/i915: reorganize
intel_drv.h"), i915_disable_vga_mem ("drm/i915: remove "extern"
keywords from intel_drv.h functions") and 20bc86739b83 ("drm/i915:
Enable/disable IPS when primary is enabled/disabled") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_drv.h
index 9b7b68fd5d47,e33f387d4185..000000000000
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@@ -696,102 -668,197 +668,196 @@@ void assert_fdi_rx_pll(struct drm_i915_
  		       enum pipe pipe, bool state);
  #define assert_fdi_rx_pll_enabled(d, p) assert_fdi_rx_pll(d, p, true)
  #define assert_fdi_rx_pll_disabled(d, p) assert_fdi_rx_pll(d, p, false)
- extern void assert_pipe(struct drm_i915_private *dev_priv, enum pipe pipe,
- 			bool state);
+ void assert_pipe(struct drm_i915_private *dev_priv, enum pipe pipe, bool =
state);
  #define assert_pipe_enabled(d, p) assert_pipe(d, p, true)
  #define assert_pipe_disabled(d, p) assert_pipe(d, p, false)
+ void intel_write_eld(struct drm_encoder *encoder,
+ 		     struct drm_display_mode *mode);
+ unsigned long intel_gen4_compute_page_offset(int *x, int *y,
+ 					     unsigned int tiling_mode,
+ 					     unsigned int bpp,
+ 					     unsigned int pitch);
+ void intel_display_handle_reset(struct drm_device *dev);
+ void hsw_enable_pc8_work(struct work_struct *__work);
+ void hsw_enable_package_c8(struct drm_i915_private *dev_priv);
+ void hsw_disable_package_c8(struct drm_i915_private *dev_priv);
+ void intel_dp_get_m_n(struct intel_crtc *crtc,
+ 		      struct intel_crtc_config *pipe_config);
+ int intel_dotclock_calculate(int link_freq, const struct intel_link_m_n *=
m_n);
+ void
+ ironlake_check_encoder_dotclock(const struct intel_crtc_config *pipe_conf=
ig,
+ 				int dotclock);
+ bool intel_crtc_active(struct drm_crtc *crtc);
 -void i915_disable_vga_mem(struct drm_device *dev);
+ void hsw_enable_ips(struct intel_crtc *crtc);
+ void hsw_disable_ips(struct intel_crtc *crtc);
+=20
+=20
+ /* intel_dp.c */
+ void intel_dp_init(struct drm_device *dev, int output_reg, enum port port=
);
+ bool intel_dp_init_connector(struct intel_digital_port *intel_dig_port,
+ 			     struct intel_connector *intel_connector);
+ void intel_dp_start_link_train(struct intel_dp *intel_dp);
+ void intel_dp_complete_link_train(struct intel_dp *intel_dp);
+ void intel_dp_stop_link_train(struct intel_dp *intel_dp);
+ void intel_dp_sink_dpms(struct intel_dp *intel_dp, int mode);
+ void intel_dp_encoder_destroy(struct drm_encoder *encoder);
+ void intel_dp_check_link_status(struct intel_dp *intel_dp);
+ bool intel_dp_compute_config(struct intel_encoder *encoder,
+ 			     struct intel_crtc_config *pipe_config);
+ bool intel_dpd_is_edp(struct drm_device *dev);
+ void ironlake_edp_backlight_on(struct intel_dp *intel_dp);
+ void ironlake_edp_backlight_off(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_on(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_off(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp);
+ void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp, bool sync);
+ void intel_edp_psr_enable(struct intel_dp *intel_dp);
+ void intel_edp_psr_disable(struct intel_dp *intel_dp);
+ void intel_edp_psr_update(struct drm_device *dev);
+=20
+=20
+ /* intel_dsi.c */
+ bool intel_dsi_init(struct drm_device *dev);
+=20
+=20
+ /* intel_dvo.c */
+ void intel_dvo_init(struct drm_device *dev);
+=20
+=20
+ /* legacy fbdev emulation in intel_fbdev.c */
+ #ifdef CONFIG_DRM_I915_FBDEV
+ extern int intel_fbdev_init(struct drm_device *dev);
+ extern void intel_fbdev_initial_config(struct drm_device *dev);
+ extern void intel_fbdev_fini(struct drm_device *dev);
+ extern void intel_fbdev_set_suspend(struct drm_device *dev, int state);
+ extern void intel_fbdev_output_poll_changed(struct drm_device *dev);
+ extern void intel_fbdev_restore_mode(struct drm_device *dev);
+ #else
+ static inline int intel_fbdev_init(struct drm_device *dev)
+ {
+ 	return 0;
+ }
 =20
- extern void intel_init_clock_gating(struct drm_device *dev);
- extern void intel_suspend_hw(struct drm_device *dev);
- extern void intel_write_eld(struct drm_encoder *encoder,
- 			    struct drm_display_mode *mode);
- extern void intel_prepare_ddi(struct drm_device *dev);
- extern void hsw_fdi_link_train(struct drm_crtc *crtc);
- extern void intel_ddi_init(struct drm_device *dev, enum port port);
-=20
- /* For use by IVB LP watermark workaround in intel_sprite.c */
- extern void intel_update_watermarks(struct drm_device *dev);
- extern void intel_update_sprite_watermarks(struct drm_plane *plane,
- 					   struct drm_crtc *crtc,
- 					   uint32_t sprite_width, int pixel_size,
- 					   bool enabled, bool scaled);
-=20
- extern unsigned long intel_gen4_compute_page_offset(int *x, int *y,
- 						    unsigned int tiling_mode,
- 						    unsigned int bpp,
- 						    unsigned int pitch);
-=20
- extern int intel_sprite_set_colorkey(struct drm_device *dev, void *data,
- 				     struct drm_file *file_priv);
- extern int intel_sprite_get_colorkey(struct drm_device *dev, void *data,
- 				     struct drm_file *file_priv);
-=20
- /* Power-related functions, located in intel_pm.c */
- extern void intel_init_pm(struct drm_device *dev);
- /* FBC */
- extern bool intel_fbc_enabled(struct drm_device *dev);
- extern void intel_update_fbc(struct drm_device *dev);
- /* IPS */
- extern void intel_gpu_ips_init(struct drm_i915_private *dev_priv);
- extern void intel_gpu_ips_teardown(void);
-=20
- /* Power well */
- extern int i915_init_power_well(struct drm_device *dev);
- extern void i915_remove_power_well(struct drm_device *dev);
-=20
- extern bool intel_display_power_enabled(struct drm_device *dev,
- 					enum intel_display_power_domain domain);
- extern void intel_init_power_well(struct drm_device *dev);
- extern void intel_set_power_well(struct drm_device *dev, bool enable);
- extern void intel_enable_gt_powersave(struct drm_device *dev);
- extern void intel_disable_gt_powersave(struct drm_device *dev);
- extern void ironlake_teardown_rc6(struct drm_device *dev);
+ static inline void intel_fbdev_initial_config(struct drm_device *dev)
+ {
+ }
+=20
+ static inline void intel_fbdev_fini(struct drm_device *dev)
+ {
+ }
+=20
+ static inline void intel_fbdev_set_suspend(struct drm_device *dev, int st=
ate)
+ {
+ }
+=20
+ static inline void intel_fbdev_restore_mode(struct drm_device *dev)
+ {
+ }
+ #endif
+=20
+ /* intel_hdmi.c */
+ void intel_hdmi_init(struct drm_device *dev, int hdmi_reg, enum port port=
);
+ void intel_hdmi_init_connector(struct intel_digital_port *intel_dig_port,
+ 			       struct intel_connector *intel_connector);
+ struct intel_hdmi *enc_to_intel_hdmi(struct drm_encoder *encoder);
+ bool intel_hdmi_compute_config(struct intel_encoder *encoder,
+ 			       struct intel_crtc_config *pipe_config);
+=20
+=20
+ /* intel_lvds.c */
+ void intel_lvds_init(struct drm_device *dev);
+ bool intel_is_dual_link_lvds(struct drm_device *dev);
+=20
+=20
+ /* intel_modes.c */
+ int intel_connector_update_modes(struct drm_connector *connector,
+ 				 struct edid *edid);
+ int intel_ddc_get_modes(struct drm_connector *c, struct i2c_adapter *adap=
ter);
+ void intel_attach_force_audio_property(struct drm_connector *connector);
+ void intel_attach_broadcast_rgb_property(struct drm_connector *connector);
+=20
+=20
+ /* intel_overlay.c */
+ void intel_setup_overlay(struct drm_device *dev);
+ void intel_cleanup_overlay(struct drm_device *dev);
+ int intel_overlay_switch_off(struct intel_overlay *overlay);
+ int intel_overlay_put_image(struct drm_device *dev, void *data,
+ 			    struct drm_file *file_priv);
+ int intel_overlay_attrs(struct drm_device *dev, void *data,
+ 			struct drm_file *file_priv);
+=20
+=20
+ /* intel_panel.c */
+ int intel_panel_init(struct intel_panel *panel,
+ 		     struct drm_display_mode *fixed_mode);
+ void intel_panel_fini(struct intel_panel *panel);
+ void intel_fixed_panel_mode(const struct drm_display_mode *fixed_mode,
+ 			    struct drm_display_mode *adjusted_mode);
+ void intel_pch_panel_fitting(struct intel_crtc *crtc,
+ 			     struct intel_crtc_config *pipe_config,
+ 			     int fitting_mode);
+ void intel_gmch_panel_fitting(struct intel_crtc *crtc,
+ 			      struct intel_crtc_config *pipe_config,
+ 			      int fitting_mode);
+ void intel_panel_set_backlight(struct drm_device *dev, u32 level, u32 max=
);
+ int intel_panel_setup_backlight(struct drm_connector *connector);
+ void intel_panel_enable_backlight(struct drm_device *dev, enum pipe pipe);
+ void intel_panel_disable_backlight(struct drm_device *dev);
+ void intel_panel_destroy_backlight(struct drm_device *dev);
+ enum drm_connector_status intel_panel_detect(struct drm_device *dev);
+=20
+=20
+ /* intel_pm.c */
+ void intel_init_clock_gating(struct drm_device *dev);
+ void intel_suspend_hw(struct drm_device *dev);
+ void intel_update_watermarks(struct drm_crtc *crtc);
+ void intel_update_sprite_watermarks(struct drm_plane *plane,
+ 				    struct drm_crtc *crtc,
+ 				    uint32_t sprite_width, int pixel_size,
+ 				    bool enabled, bool scaled);
+ void intel_init_pm(struct drm_device *dev);
+ bool intel_fbc_enabled(struct drm_device *dev);
+ void intel_update_fbc(struct drm_device *dev);
+ void intel_gpu_ips_init(struct drm_i915_private *dev_priv);
+ void intel_gpu_ips_teardown(void);
+ int i915_init_power_well(struct drm_device *dev);
+ void i915_remove_power_well(struct drm_device *dev);
+ bool intel_display_power_enabled(struct drm_device *dev,
+ 				 enum intel_display_power_domain domain);
+ void intel_display_power_get(struct drm_device *dev,
+ 			     enum intel_display_power_domain domain);
+ void intel_display_power_put(struct drm_device *dev,
+ 			     enum intel_display_power_domain domain);
+ void intel_init_power_well(struct drm_device *dev);
+ void intel_set_power_well(struct drm_device *dev, bool enable);
+ void intel_enable_gt_powersave(struct drm_device *dev);
+ void intel_disable_gt_powersave(struct drm_device *dev);
+ void ironlake_teardown_rc6(struct drm_device *dev);
  void gen6_update_ring_freq(struct drm_device *dev);
+ void gen6_rps_idle(struct drm_i915_private *dev_priv);
+ void gen6_rps_boost(struct drm_i915_private *dev_priv);
+ void intel_aux_display_runtime_get(struct drm_i915_private *dev_priv);
+ void intel_aux_display_runtime_put(struct drm_i915_private *dev_priv);
+ void ilk_wm_get_hw_state(struct drm_device *dev);
+=20
+=20
+ /* intel_sdvo.c */
+ bool intel_sdvo_init(struct drm_device *dev, uint32_t sdvo_reg, bool is_s=
dvob);
+=20
+=20
+ /* intel_sprite.c */
+ int intel_plane_init(struct drm_device *dev, enum pipe pipe, int plane);
+ void intel_flush_primary_plane(struct drm_i915_private *dev_priv,
+ 			       enum plane plane);
+ void intel_plane_restore(struct drm_plane *plane);
+ void intel_plane_disable(struct drm_plane *plane);
+ int intel_sprite_set_colorkey(struct drm_device *dev, void *data,
+ 			      struct drm_file *file_priv);
+ int intel_sprite_get_colorkey(struct drm_device *dev, void *data,
+ 			      struct drm_file *file_priv);
+=20
 =20
- extern bool intel_ddi_get_hw_state(struct intel_encoder *encoder,
- 				   enum pipe *pipe);
- extern int intel_ddi_get_cdclk_freq(struct drm_i915_private *dev_priv);
- extern void intel_ddi_pll_init(struct drm_device *dev);
- extern void intel_ddi_enable_transcoder_func(struct drm_crtc *crtc);
- extern void intel_ddi_disable_transcoder_func(struct drm_i915_private *de=
v_priv,
- 					      enum transcoder cpu_transcoder);
- extern void intel_ddi_enable_pipe_clock(struct intel_crtc *intel_crtc);
- extern void intel_ddi_disable_pipe_clock(struct intel_crtc *intel_crtc);
- extern void intel_ddi_setup_hw_pll_state(struct drm_device *dev);
- extern bool intel_ddi_pll_mode_set(struct drm_crtc *crtc);
- extern void intel_ddi_put_crtc_pll(struct drm_crtc *crtc);
- extern void intel_ddi_set_pipe_settings(struct drm_crtc *crtc);
- extern void intel_ddi_prepare_link_retrain(struct drm_encoder *encoder);
- extern bool
- intel_ddi_connector_get_hw_state(struct intel_connector *intel_connector);
- extern void intel_ddi_fdi_disable(struct drm_crtc *crtc);
-=20
- extern void intel_display_handle_reset(struct drm_device *dev);
- extern bool intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,
- 						  enum pipe pipe,
- 						  bool enable);
- extern bool intel_set_pch_fifo_underrun_reporting(struct drm_device *dev,
- 						 enum transcoder pch_transcoder,
- 						 bool enable);
-=20
- extern void intel_edp_psr_enable(struct intel_dp *intel_dp);
- extern void intel_edp_psr_disable(struct intel_dp *intel_dp);
- extern void intel_edp_psr_update(struct drm_device *dev);
- extern void hsw_disable_lcpll(struct drm_i915_private *dev_priv,
- 			      bool switch_to_fclk, bool allow_power_down);
- extern void hsw_restore_lcpll(struct drm_i915_private *dev_priv);
- extern void ilk_enable_gt_irq(struct drm_i915_private *dev_priv, uint32_t=
 mask);
- extern void ilk_disable_gt_irq(struct drm_i915_private *dev_priv,
- 			       uint32_t mask);
- extern void snb_enable_pm_irq(struct drm_i915_private *dev_priv, uint32_t=
 mask);
- extern void snb_disable_pm_irq(struct drm_i915_private *dev_priv,
- 			       uint32_t mask);
- extern void hsw_enable_pc8_work(struct work_struct *__work);
- extern void hsw_enable_package_c8(struct drm_i915_private *dev_priv);
- extern void hsw_disable_package_c8(struct drm_i915_private *dev_priv);
- extern void hsw_pc8_disable_interrupts(struct drm_device *dev);
- extern void hsw_pc8_restore_interrupts(struct drm_device *dev);
- extern void intel_aux_display_runtime_get(struct drm_i915_private *dev_pr=
iv);
- extern void intel_aux_display_runtime_put(struct drm_i915_private *dev_pr=
iv);
+ /* intel_tv.c */
+ void intel_tv_init(struct drm_device *dev);
 =20
  #endif /* __INTEL_DRV_H__ */

--Signature=_Mon__28_Oct_2013_16_58_48_+1100_3+5m/diQvMpQseTe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbf0cAAoJEMDTa8Ir7ZwV8/IP/j7VZXUWVxAQDYcEh+tz1BcY
pwTr7qOMNqvGeDGZOYUz0MtXThXTEniiMsjr9DM652+d48c7YEIEzcUCuMw7lPcw
KM+7t4cn8V5nnN0+zRfBk0tttpwCsHiABs6b4WhPkmkuFWBsFCm2+qfO2RMiwAxy
L93YallTxZPGR0hJylU7GsQPjCajCcav0cJ90AZGY2EMS6Nu5inO17l90XyzyPUX
otvUPuom7+NXzj/vrJqOHZsqLWQr0yXHaaholAGpEqmwjtgzylBx3Ya4mpkWq+4Z
VfAA5D6Qs2Bn4OXutoPCZbeeCLxaYbwi0SYriFb1CMTU1o0ttEtyXgPBCcAx6kX5
ehNHk4y+QglZ+fMbHvr6u7Bmhp4CdhlD3+bCng6UXVGaVQF83mXUeuyHEKpwOku7
xbpSuELJUVmOTcXQH4eIWLnJUKKzRG1xc/VLqxjnZInXbAHh0I/9PLAfZLRryV1k
SVHg8rYFPWu5wq5Oypn1r50UDsVMYE2zWSNmhIZ7L377nqMq6B+E0q2YI5WFBD+Q
vip0dDjf0qcauyH5ywqM28zF6RxKjKiey757hBAbqF7451E8IUFm6c2wdgcW0fa+
+0g/Qq2aUuCpK9XpD6AIOlqYgr1omII+0KOkxLkozBnt5p6W/0icTDqItLRGKyZp
6DfvrXZTFJLBi7zkdVoU
=zZZz
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_16_58_48_+1100_3+5m/diQvMpQseTe--
